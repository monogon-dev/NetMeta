# Upgrade from stable to main

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