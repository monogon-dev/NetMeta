#!/usr/bin/env bash
# Build container bundle using Bazel and import it to the local k3s image store.
# This bypasses the need for a local registry for development, similar to the trickery minikube does.
set -euo pipefail

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin

# TODO(leo): replace with a Bazel rule

function build() {
  local target=$1

  bazel build //${target}.tar

  local location=$(bazel cquery ${target/:/\//}.tar \
    --output starlark \
    --starlark:expr="target.files.to_list()[0].path")

  k3s ctr images import --digests ${location} 1>&2
  local digest=$(crictl inspecti bazel/${target} 2>&1 | jq -r '.status.repoDigests[0] | split("@")[-1]')

  # "docker.io/bazel" is hardcoded in rules_docker. Specifying a digest does not work with a local image, therefore, we
  # need force the pod to redeploy when the digest changes by adding a digest annotation on the deployment.
  echo "{image: \"docker.io/bazel/${target}\", digest: \"${digest}\"}"
}

cat <<EOF > deploy/single-node/images_local.cue
package k8s

netmeta: images: {
  helloworld: $(build cmd/helloworld:helloworld)
  risinfo: $(build cmd/risinfo:risinfo)
  goflow: $(build third_party/goflow:goflow)
  portmirror: $(build cmd/portmirror:portmirror)
  grafana: $(build third_party/grafana:grafana)
}
EOF
