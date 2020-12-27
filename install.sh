#!/bin/bash
set -euo pipefail
#
# Installer for a single-node NetMeta production deployment.
#
# Tested on amd64 with:
#
#   - CentOS 8
#   - Debian 10
#   - Ubuntu 18.04 LTS
#
# Idempotent, safe to run multiple times. A single-node deployment can be safely
# upgraded by re-running the install script.
#
# This installer pulls in binaries from, and therefore trusts, third-party sources:
#
#  - k3s.io by Rancher Labs.
#  - Go binary distribution by Google.
#  - ClickHouse container images by Yandex.
#  - Strimzi Kafka container images by Red Hat.
#  - goflow container images by CloudFlare.
#
# All downloads happen via SSL and are fully open source.
#
# We build most dependencies from source, except for the larger binary dependencies
# listed above. It's possible to build these from source as well. If you need this
# for security or compliance reasons, please contact us so we can gauge interest.
#
# Might not eat existing data - we strongly recommend to run the NetMeta single
# node deployment on a dedicated host for both security and performance reasons.
#
# Install Go binary. We need Go to build other dependencies.

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Ensure that our binaries are not shadowed by the distribution.
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:/bin

ARCH=amd64
GO=1.14.6

(
  if [[ -d /usr/local/go ]]; then
    rm -rf /usr/local/go
  fi

  TMP=$(mktemp -d)

  (
    cd "$TMP"
    curl -OJ "https://dl.google.com/go/go${GO}.linux-${ARCH}.tar.gz"
    tar -C /usr/local -xzf "go${GO}.linux-${ARCH}.tar.gz"

    echo 'PATH=/usr/local/go/bin:$PATH' >/etc/profile.d/local_go.sh
  )

  rm -rf "$TMP"
)

. /etc/profile.d/local_go.sh

# Install Go dependencies. Dependency versions and hashes are pinned using the
# Go module mechanism.

(
  cd third_party/tools
  go build -o /usr/local/bin/cue cuelang.org/go/cmd/cue
  go build -o /usr/local/bin/bazel github.com/bazelbuild/bazelisk
)

# Install k3s. k3s is a minimal Kubernetes distribution we use to deploy the various pieces of NetMeta.
#
# We do not want to expose any unnecessary public services since users might disregard documentation
# and forget about the host firewall. k3s defaults to run literally everything publicly - hammer it into shape.
#
# This leaves us with apiserver and kubelet on public ports, both of which are designed for public exposure.
#
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.20.0+k3s2" INSTALL_K3S_EXEC="server
  --disable-cloud-controller
  --kube-scheduler-arg=address=127.0.0.1
  --kube-controller-manager-arg=address=127.0.0.1
  --disable traefik
" sh -s -

while ! k3s kubectl get all; do
  echo "Waiting for k3s..."
  systemctl status k3s.service
  sleep 5
done
