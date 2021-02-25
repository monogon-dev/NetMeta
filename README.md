# NetMeta

⚠️ **PRE-RELEASE**: This is a work in progress - please watch this repo for news.

NetMeta is a scalable network observability toolkit optimized for performance.

Flows are not pre-aggregated and stored with one second resolution. This allows for 
queries in arbitrary dimensions with high-fidelity graphs.

It captures, aggregates and analyzes events from a variety of data sources:

* sFlow
* NetFlow/IPFIX
* Linux NFLOG (soon)
* Linux conntrack (soon)
* Web server logs (soon)
* Scamper traces (soon)
* GCP VPC Flow Logs (soon)
* AWS VPC Flow Logs (soon)


<img src="https://i.imgur.com/kl2ThBc.png" width="550px" alt="" />
<img src="https://i.imgur.com/lt0LFqh.png" width="550px" alt="" />
<img src="https://user-images.githubusercontent.com/859697/103421113-10df0f00-4b9b-11eb-8747-7ccd9c8af76c.png" width="100%" alt="" />

Sampling rate is detected automatically. Different devices with different sampling rates can be mixed.
IPv6 is fully supported throughout the stack.

NetMeta is powered by a number of great open source projects: we use [ClickHouse](https://clickhouse.tech) as the main
database, [Kafka](https://kafka.apache.org) as a queue in front of ClickHouse, [Grafana](https://grafana.com/) with
[clickhouse-grafana](https://github.com/Vertamedia/clickhouse-grafana) as frontend,
[goflow](https://github.com/cloudflare/goflow) as the sFlow/Netflow collector, [Strimzi](https://strimzi.io/) to deploy
Kafka, [clickhouse-operator](https://github.com/Altinity/clickhouse-operator) to deploy ClickHouse, as well as
[Kubernetes](https://kubernetes.io/) and Rancher's [k3s](https://k3s.io/).

NetMeta is **alpha software** and subject to change.

### sFlow vs Netflow/IPFIX

**sFlow** is a very simple protocol. In its simplest form, every n-th packet is sampled and the packet header is sent
to the collector. That's it. The rate of samples sent to the collector and the bandwidth required is very predictable
and proportional to observed pps.

**Netflow/IPFIX** also samples every n-th packet, but pre-aggregates data on the network device, typically identified by
its 5-tuple, and exports metadata for all active flows at regular intervals. Netflow aggregation is stateful and the 
device needs to maintain a flow table. This is particularly useful for use cases that care about individual flows 
(connections), like network security monitoring. As long as most packets belong to a small number of flows, much fewer
samples are sent to the collector at the same sampling rate.

Of course, pre-aggregation means that we lose data about the individual packets. This is fine for use cases like traffic
 accounting, but has disadvantages for observability:


* Resolution is inherently limited by the aggregation interval (flow timeout). The lower end for this is typically 10s
  or more - you couldn't distinguish a 1s burst at 100 Gbps from a 10s burst at 10 Gbps.
 
* Does this flow consist of only SYN packets? SYN-ACKs? A mixture of both? We can't tell, because the TCP flags in the 
  flow metadata are a union of all individual packet's TCP flags.

* In adverserial network conditions, like DDoS attacks using random source IP and ports, each packet can represent a new
  flow. This can quickly fill up the flow table, resulting in dropped flows, losing visibility in a situation where it
  would be particularly useful. The rate of samples sent to the collector is hard to reason about, since it is
  implementation-specific and depends on flow cardinality, table size and timeouts.
  
* Maintaining the stateful flow table in the router is very expensive, especially at high rates. Modern column stores 
  like ClickHouse are extremely efficient at aggregating data in arbitrary dimensions - there's no need to do it on the router.

If possible, we recommend using sFlow. For a 10 Gbps link, a typical sampling rate is 1:2000.
A worst-case flood at line rate would generate 7kpps of sFlow samples.

If Netflow/IPFIX is used, make sure to pick an appropriate sampling rate and flow table size for worst-case workloads. 
There are many different implementations that perform very differently - refer to vendor documentation for specifics.

Depending on your aggregation interval, you may want to set a minimum display interval in the NetMeta config:

    dashboardDisplay: minInterval: "15s"

### API Stability

NetMeta is alpha software and subject to change. It exposes the following APIs:

* The cluster configuration file for single-node deployments.
* ClickHouse SQL schema for raw database access.
* Protobuf schemas for ingestion for writing custom processors.

One NetMeta has stabilized, these APIs will be stable and backwards compatible.

## Deployment

NetMeta includes a production-ready single node deployment that scales to up to ~100k events/s and billions of database rows.

Ingestion performance is limited by CPU performance and disk bandwidth. 
Query performance is limited by disk and memory bandwidth, as well as total amount of available memory for larger in-memory aggregations.

Most reads/writes are sequential due to heavy use of batching in all parts of the stack, 
and it works fine even on network storage or spinning disks. We recommend local NVMe drives for best performance.

NetMeta can scale to millions of events per seconds in multi-node deployments.

### Single-node deployment

Single-node deployment is tested on CentOS/RHEL 7 + 8, Debian 10 and Ubuntu 18.04 LTS. 

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
git clone https://github.com/leoluk/NetMeta && cd NetMeta

# Install dependencies
./install.sh

# Build containers
scripts/build_containers.sh

# Edit config file (see below)

# Deploy single node
cd deploy/single-node
cue apply ./...

# Apply SQL migrations (work in progress - will be automated in the future)
# Wait for all pods to be running first (kubectl get pod -w). No error means it worked.
kubectl exec -i chi-netmeta-netmeta-0-0-0 -c clickhouse -- clickhouse-client -mn < schema/1_init.up.sql
```

Common errors during deployment:

- A local firewall blocks internal traffic and prevents pods from starting (see below).
- Missing required fields in the config (`incomplete value`, see below).
- It may take a few minutes for the cluster to converge, especially if downloads are slow.
  It's normal for goflow to be in a `crashloopbackoff` state while it waits for Kafka to exist.

#### Configuration

NetMeta expects a config file at `deploy/single-node/config_local.cue`. Check 
[config.cue](deploy/single-node/config.cue) for all available settings.

Minimal config for a working installation:

```yaml
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

```yaml
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

```yaml
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

#### Firewall config

We recommend a host- or network-level firewall to restrict access to the server running NetMeta.

The following ports are exposed by default:

| Port      | Description                                                | Recommendation |
|-----------|------------------------------------------------------------|----------------|
| 80/tcp    | Frontend web server (redirects to HTTPS)                   | Allow for users
| 443/tcp   | Frontend web server                                        | Allow for users
| 2055/udp  | NetFlow / IPFIX                                            | Restrict to device IPs
| 2056/udp  | NetFlow v5                                                 | Restrict to device IPs
| 6343/udp  | sFlow                                                      | Restrict to device IPs
| 6443/tcp  | k8s master API                                             | Block, unless you need it for external monitoring
| 10250/tcp | k8s kubelet metrics                                        | Block, unless you need it for external monitoring

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

##### firewalld example config

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

### Host sFlow collector

We recommend [hsflowd](https://github.com/sflow/host-sflow) for host-based flow collection.

Example /etc/hsflowd.conf config:

    sflow {
      collector { ip=flowmon.example.com udpport=6343 }
      nflog { group = 5  probability = 0.0025 }
    }

You need to create iptables (or nftables) rules that send samples to hsflowd's nflog group.
An example config for plain iptables looks like this:

```bash
# hsflowd sampling. Probability needs to match /etc/hsflowd.conf (it will be used to calculate sampling rate).

MOD_STATISTIC="-m statistic --mode random --probability 0.0025"
NFLOG_CONFIG="--nflog-group 5 --nflog-prefix SFLOW"
INTERFACE=eno1

iptables -t raw -I PREROUTING -i $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
iptables -t nat -I POSTROUTING -o $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
iptables -t nat -I OUTPUT -o $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
ip6tables -t raw -I PREROUTING  -i $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
ip6tables -t nat -I POSTROUTING -o $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
ip6tables -t nat -I OUTPUT -o $INTERFACE -j NFLOG $MOD_STATISTIC $NFLOG_CONFIG
```

For Linux hosts, there's a custom agent on the roadmap that directly pushes to Kafka to avoid the sFlow detour
and get better data that includes the flow direction.
In the meantime, hsflowd is your best bet for collecting samples from a host.

### Port Mirror collector

If you have a Interface Pair that receives a copy of your Traffic e.G. Switch Portmirror, Fibre Taps, etc. you can use
this as your collector. For this you have to set it up in the config like this:

```yaml
netmeta: config: {
    [...]
    portMirror: {
      interfaces: "tap_rx:tap_tx,tap2_rx:tap2_tx"
      sampleRate: 100
    }
}
```

You have to configure which interfaces the collector should listen on. You can have multiple pairs by 
seperating them with a comma. You can also configure the sample rate.

### nxtOS

Stay tuned - NetMeta will be a first-class citizen on our nxtOS Kubernetes cluster operating system. 

### Kubernetes

NetMeta works on any Kubernetes cluster that supports LoadBalancer and Ingress objects and can provision storage. 
It's up to you to carefully read the deployment code and cluster role assigments to make sure it works with your cluster.
Note that we use two operators, which require cluster-admin permissions since CRDs are global 
([Strimzi](https://strimzi.io/docs/master) for Kafka and [clickhouse-operator](https://github.com/Altinity/clickhouse-operator)).

All pieces of NetMeta are installed into a single namespace. By default, this is ``default``, which is probably not what you want.
You can change the target namespace in the deployment config.

Please contact us if you need help porting NetMeta to an existing k8s cluster.

### Multi-node deployment

Work In Progress. Please contact us if you're interested in large-scale deployments.

### Architecture

<img src="https://i.imgur.com/j8lBemH.png" alt="Single Node Dataflow" width="350px" />

---

(C) 2020 Nexantic GmbH. This is not (yet?) an official Nexantic product. 

This software is provided "as-is" and
without any express or implied warranties, including, without limitation, the implied warranties of
merchantability and fitness for a particular purpose. 
