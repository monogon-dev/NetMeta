#!/bin/bash
set -euo pipefail
# Fast ConfigMap refresh for development. Updating the annotation on the pod causes the configmap update to be applied
# immediately, rather than depending on kubelet timers.

cue apply-cm

kubectl annotate --overwrite pod/grafana-0 meta/poked-with-stick=yes
