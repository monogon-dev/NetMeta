# Clickhouse Operator

The CUE schema is generated via these commands:
- `curl -s https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install-template.yaml | \
  OPERATOR_IMAGE="altinity/clickhouse-operator:0.20.0@sha256:ce97ab34323602b37a0dd9fb45d7f0efa32e8a2c3ae2204339771d3d33e49ccb" \
  OPERATOR_NAMESPACE="default" \
  OPERATOR_IMAGE_PULL_POLICY="IfNotPresent" \
  METRICS_EXPORTER_IMAGE="altinity/metrics-exporter:0.20.0@sha256:1987abf883a6a51b26070cb410240630279ce7fccf0c5f4483acf1b5f7dd4a1f" \
  METRICS_EXPORTER_NAMESPACE="default" \
  METRICS_EXPORTER_IMAGE_PULL_POLICY="IfNotPresent" \
  envsubst > clickhouse-operator.yaml`
- `cue import clickhouse-operator.yaml -l kind -l metadata.name -p k8s -f`
- `rm clickhouse-operator.yaml`
