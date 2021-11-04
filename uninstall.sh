#!/bin/bash
# Remove all pieces of NetMeta. No promises!

rm -rf /usr/local/go
rm /etc/profile.d/local_go.sh
rm /usr/local/bin/cue
rm /usr/local/bin/ko

k3s-uninstall.sh

# Ok to fail on non-SELinux distros
yum -y remove k3s-selinux

# TODO: remove the yum GPG key k3s installs these days
