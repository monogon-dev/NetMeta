# Strimzi Kafka Operator

The CUE schema is generated via these commands:
- `wget https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.31.1/strimzi-cluster-operator-0.31.1.yaml`
- `cue import strimzi-cluster-operator-0.31.1.yaml -l kind -l metadata.name -p k8s -f`
- `rm strimzi-cluster-operator-0.31.1.yaml`

The Upstream file contains an empty yaml object at the end of the stream which you have to delete. Else you will get the following error:
```
error evaluating label kind: reference "kind" not found
```
