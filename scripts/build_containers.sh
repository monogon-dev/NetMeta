#!/bin/bash
# Build container bundle using Bazel and import it to the local k3s image store.
# This bypasses the need for a local registry for development, similar to the trickery minikube does.
set -euo pipefail

# TODO(leo): replace with a Bazel rule

function build() {
  local target=$1

  bazel build //${target}.tar
  ctr images import --digests bazel-bin/${target/:/\//}.tar 1>&2

  crictl inspecti bazel/${target} 2>&1 | jq -r .status.repoDigests[0]
}

cat <<EOF > deploy/single-node/images_local.cue
NetMetaImages :: {
  helloworld: "$(build cmd/helloworld:helloworld)"
}
EOF
