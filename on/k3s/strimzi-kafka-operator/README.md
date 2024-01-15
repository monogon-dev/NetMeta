# Strimzi Kafka Operator

The CUE schema is generated via these commands:
- `curl "https://strimzi.io/install/latest?namespace=default" > strimzi-cluster-operator.yaml`
- `cue import strimzi-cluster-operator.yaml -l kind -l metadata.name -p k8s -f`
- `rm strimzi-cluster-operator.yaml`

The upstream file contains an empty yaml object at the end of the stream which you have to delete. Else you will get the following error:
```
error evaluating label kind: reference "kind" not found
```
