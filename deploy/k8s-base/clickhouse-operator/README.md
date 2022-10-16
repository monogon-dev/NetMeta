# Clickhouse Operator

The CUE schema is generated via these commands:
- `wget https://raw.githubusercontent.com/Altinity/clickhouse-operator/release-0.19.3/deploy/operator/clickhouse-operator-install-bundle.yaml`
- `cue import clickhouse-operator-install-bundle.yaml -l kind -l metadata.name -p k8s -f`
- `rm clickhouse-operator-install-bundle.yaml`
