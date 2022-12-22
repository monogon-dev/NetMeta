# Upgrade guidance
## Upgrade from stable to main

Upgrading from the stable branch to the main branch, or upgrading on the main branch from a commit before Oct 20, 2022, requires a manual migration with downtime.

```
# Be sure to have apparmor-utils installed (apparmor_parser is required by k3s)

./install.sh

./scripts/build_containers.sh
cd deploy/single-node/

# Edit your config_local.cue
# Replace clickhouseOperatorPassword with clickhouseAdminPassword

kubectl delete crd \
kafkaconnectors.kafka.strimzi.io \
kafkaconnectors.kafka.strimzi.io \
kafkaconnects.kafka.strimzi.io \
kafkamirrormaker2s.kafka.strimzi.io \
kafkas.kafka.strimzi.io \
kafkamirrormakers.kafka.strimzi.io \
kafkabridges.kafka.strimzi.io

kubectl patch clickhouseinstallation netmeta --type json -p='[{"op": "remove", "path": "/spec/templates/podTemplates/0/podDistribution"}]'
kubectl patch clickhouseinstallation netmeta --type json -p='[{"op": "remove", "path": "/spec/templates/podTemplates/0/zone/values"}]'
kubectl patch clickhouseinstallation netmeta --type json -p='[{"op": "remove", "path": "/status/errors"}]'

cue apply

# Wait for pods to rollout
kubectl get pods -w

kubectl exec -i chi-netmeta-netmeta-0-0-0 -c clickhouse -- clickhouse-client -q 'DROP TABLE flows_queue'
kubectl exec -i chi-netmeta-netmeta-0-0-0 -c clickhouse -- clickhouse-client -q 'DROP VIEW flows_raw_view'

GOOSE_DRIVER=clickhouse \
GOOSE_DB_USER=admin \
GOOSE_DB_PASS=$(cue export -e netmeta.config.clickhouseAdminPassword --out text) \
GOOSE_DB_ADDR=$(kubectl get pod chi-netmeta-netmeta-0-0-0 --template '{{.status.podIP}}') \
GOOSE_DBSTRING="tcp://$GOOSE_DB_USER:$GOOSE_DB_PASS@$GOOSE_DB_ADDR:9000/default" \
GOOSE_MIGRATION_DIR="schema/" \
goose up

# If you access NetMeta from external infrastructure (e.g. your own Grafana), you have to change the username from `clickhouse_operator` to `admin`
```

## Migrate to IPv4-mapped IPv6 addresses
This can take a long time...

```clickhouse
INSERT INTO flows_raw
WITH
    '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' AS IPv6v4NullPadding,
    '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' AS IPv6Null,
    '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff' AS IPv6v4RFCPadding
SELECT * REPLACE (
    if(startsWith(SamplerAddress, IPv6v4NullPadding),
       reinterpret(toFixedString(IPv6v4RFCPadding || substr(SamplerAddress, 13, 16), 16), 'IPv6'), SamplerAddress) AS SamplerAddress,
    if(startsWith(SrcAddr, IPv6v4NullPadding),
       reinterpret(toFixedString(IPv6v4RFCPadding || substr(SrcAddr, 13, 16), 16), 'IPv6'), SrcAddr) AS SrcAddr,
    if(startsWith(DstAddr, IPv6v4NullPadding),
       reinterpret(toFixedString(IPv6v4RFCPadding || substr(DstAddr, 13, 16), 16), 'IPv6'), DstAddr) AS DstAddr,
    if(startsWith(NextHop, IPv6v4NullPadding) and NextHop != IPv6Null,
       reinterpret(toFixedString(IPv6v4RFCPadding || substr(NextHop, 13, 16), 16), 'IPv6'), NextHop) AS NextHop
    )
FROM flows_raw;

-- Delete data with the old non-compliant mapping
ALTER TABLE flows_raw
DELETE WHERE
    startsWith(SamplerAddress, '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00') OR
    startsWith(SrcAddr, '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00') OR
    startsWith(DstAddr, '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00');
```