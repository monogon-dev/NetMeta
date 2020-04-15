#!/bin/bash
# Remove all pieces of NetMeta. No promises!

rm -rf /usr/local/go
rm /etc/profile.d/local_go.sh
rm /usr/local/bin/cue

k3s-uninstall.sh

# Ok to fail on non-SELinux distros
yum -y remove k3s-selinux
