#!/bin/bash
# Build container bundle using Bazel and import it to the local k3s image store.
# This bypasses the need for a local registry for development, similar to the trickery minikube does.
set -euo pipefail

export PATH=/usr/local/bin:/usr/local/go/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin

function build() {
  local target=$1
  local package=$2

  local tmpfile=$(mktemp)
  trap "rm -f $tmpfile" EXIT

  (
    cd "$target"
    KO_DOCKER_REPO=netmeta.local/${target} ko publish ${package} --tarball "$tmpfile" --push=false | cut -d'@' -f1
  )

  k3s ctr images import "$tmpfile" 1>&2
}

cat <<EOF > deploy/single-node/images_local.cue
package k8s

netmeta: images: #NetMetaImages & {
  helloworld: "$(build cmd/helloworld github.com/monogon-dev/NetMeta/cmd/helloworld)"
  risinfo: "$(build cmd/risinfo github.com/monogon-dev/NetMeta/cmd/risinfo)"
  goflow: "$(build third_party/goflow github.com/netsampler/goflow2/cmd/goflow2)"
  portmirror: "$(build cmd/portmirror github.com/monogon-dev/NetMeta/cmd/portmirror)"
}
EOF
