# Clickhouse Operator

The CUE schema is generated via these commands:
- `curl -s https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install-template.yaml | \
  OPERATOR_IMAGE="altinity/clickhouse-operator:0.21.0@sha256:8f481827d60398d0c553ea7c1726c0acec4ca893af710333ea5aa795ca96c0b9" \
  OPERATOR_NAMESPACE="default" \
  OPERATOR_IMAGE_PULL_POLICY="IfNotPresent" \
  METRICS_EXPORTER_IMAGE="altinity/metrics-exporter:0.21.0@sha256:a9743f3c012400e122abc470a3e4c95a7ab25ab3025df1e6d7f98af75f627215" \
  METRICS_EXPORTER_NAMESPACE="default" \
  METRICS_EXPORTER_IMAGE_PULL_POLICY="IfNotPresent" \
  envsubst > clickhouse-operator.yaml`
- `cue import clickhouse-operator.yaml -l kind -l metadata.name -p k8s -f`
- `rm clickhouse-operator.yaml`
