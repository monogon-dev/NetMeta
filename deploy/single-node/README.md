# Single-node deployment

Single-node deployment is tested on CentOS/RHEL 7 + 8, Debian 10 and Ubuntu 18.04 LTS + 20.04 LTS.

We strongly recommend deploying NetMeta on a dedicated VM or physical server.

Deployment is designed to be compatible with hosts that are managed by an organization's configuration management baseline.
The NetMeta single-node deployment is self-contained and does not touch any of the system's global configuration.
Make sure to read and understand install.sh before you run it! It can co-exist with other services on the same machine,
but we do not recommend that.

Build dependencies:

- Python >=3.6 (rules_docker)
- C compiler toolchain (protoc)

Install build dependencies on RHEL/CentOS 7:

    yum install -y jq "@Development Tools"

Install build dependencies on RHEL/CentOS 8 and Fedora:

```bash
dnf install -y python3 jq "@Development Tools"

# TODO(leo): ugh - figure out how to convince Bazel to use the python3 binary
ln -s /usr/bin/python3 /usr/local/bin/python
```

On Fedora >= 32, disable cgroupsv2, which is [not yet supported by k3s](https://github.com/rancher/k3s/issues/900):

    grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
    reboot

Install build dependencies on Debian Buster and Ubuntu 18.04:

    apt install -y jq gcc git gcc python curl g++

We will eventually provide pre-built images, for now, the build dependencies are always required.

Quick start:

```bash
git clone https://github.com/monogon-dev/NetMeta && cd NetMeta

# Install dependencies
./install.sh

# Build containers
scripts/build_containers.sh

# Edit config file (see below)

# Deploy single node
cd deploy/single-node
cue apply ./...

# Apply SQL migrations
# Wait for all pods to be running first (kubectl get pod -w). No error means it worked.
GOOSE_DRIVER=clickhouse 
GOOSE_DB_USER=clickhouse_operator
GOOSE_DB_PASS=$(cue export -e netmeta.config.clickhouseOperatorPassword --out text)
GOOSE_DB_ADDR=$(kubectl get pod chi-netmeta-netmeta-0-0-0 --template '{{.status.podIP}}')
GOOSE_DBSTRING="tcp://$GOOSE_DB_USER:$GOOSE_DB_PASS@$GOOSE_DB_ADDR:9000/default"
GOOSE_MIGRATION_DIR="schema/" 
goose up
```

Common errors during deployment:

- A local firewall blocks internal traffic and prevents pods from starting (see below).
- Missing required fields in the config (`incomplete value`, see below).
- It may take a few minutes for the cluster to converge, especially if downloads are slow.
  It's normal for goflow to be in a `crashloopbackoff` state while it waits for Kafka to exist.

## Configuration

NetMeta expects a config file at `deploy/single-node/config_local.cue`. Check
[config.cue](config.cue) for all available settings.

Minimal config for a working installation:

```cue
package k8s

netmeta: config: {
    grafanaInitialAdminPassword: "<generate and paste secret here>"
    clickhouseOperatorPassword:  "<generate and paste secret here>"
    sessionSecret:               "<generate and paste secret here>"

    publicHostname: "flowmon.example.com"

    letsencryptMode:        "staging"  // change to "production" later
    letsencryptAccountMail: "letsencrypt@example.com"
}
```

You can run `./example-config.sh > deploy/single-node/config_local.cue` to generate a config template
with generated random values.

If you use GSuite, configure authentication:

```cue
netmeta: config: {
    [...]

    grafanaGoogleAuth: {
        clientID:     "[...].apps.googleusercontent.com"
        clientSecret: "[...]"
        allowedDomains: ["corp.example"]
    }

    // Include this if all users should be granted Editor permission.
    // Otherwise, you'll have to grant permissions manually.
    grafanaDefaultRole: "Editor"
}
```

You can manually resolve numeric interface IDs (also known as "SNMP ID") to human-readable interface names:

```cue
netmeta: config: {
    [...]

    interfaceMap: [
        {device: "::100.0.0.1", idx: 858, description:  "TRANSIT-ABC"},
        {device: "::100.0.0.1", idx: 1126, description: "PEERING-YOLO-COLO"},
    ]
}
```

After changing the configuration, run `cue apply-prune ./...` in deploy/single-node to apply it.

If you receive an `incomplete value` error, it means that one or more required values are missing.
Run `cue eval -c ./...` to figure out which ones.

## Firewall config

We recommend a host- or network-level firewall to restrict access to the server running NetMeta.

The following ports are exposed by default:

| Port      | Description                              | Recommendation                                    |
|-----------|------------------------------------------|---------------------------------------------------|
| 80/tcp    | Frontend web server (redirects to HTTPS) | Allow for users                                   |
| 443/tcp   | Frontend web server                      | Allow for users                                   |
| 2055/udp  | NetFlow / IPFIX                          | Restrict to device IPs                            |
| 2056/udp  | NetFlow v5                               | Restrict to device IPs                            |
| 6343/udp  | sFlow                                    | Restrict to device IPs                            | 
| 6443/tcp  | k8s master API                           | Block, unless you need it for external monitoring |
| 10250/tcp | k8s kubelet metrics                      | Block, unless you need it for external monitoring |

Service ports can be changed in the node configuration (see above).

All services except for NetFlow/IPFIX/sFlow are authenticated.

If you disable public access to the frontend web server, Let's Encrypt certificate provisioning won't
work and you'll have to configure a static SSL certificate.

The flow collection protocols have
no authentication and are vulnerable to DoS and flow data spoofing - we recommend you restrict them to internal networks.

You also need to allow internal traffic on the host:

```
iptables -I INPUT -i cni0 -j ACCEPT
iptables -I FORWARD -i cni0 -j ACCEPT
iptables -I OUTPUT -o cni0 -j ACCEPT
```

### firewalld example config

This assumes a default firewalld config with "public" as your default zone.

Allow public access to Grafana:

    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --permanent --zone=public --add-service=https

Allow access to flow collector for source IP ranges:

    firewall-cmd --permanent --new-zone=flowsources
    firewall-cmd --permanent --zone=flowsources --add-port=2055/udp
    firewall-cmd --permanent --zone=flowsources --add-port=2056/udp
    firewall-cmd --permanent --zone=flowsources --add-port=6343/udp
    
    firewall-cmd --permanent --add-source=100.1.1.1/22 --zone=flowsources
    [...]

Create a new zone for the cni0 interface and allow internal traffic:

    firewall-cmd --permanent --new-zone=cni
    firewall-cmd --permanent --add-interface=cni0 --zone=cni
    firewall-cmd --permanent --zone=cni --set-target=ACCEPT

Reload config:

    firewall-cmd --reload