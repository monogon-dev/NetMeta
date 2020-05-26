FROM fedora:32

RUN INSTALL_PKGS="iptables" && \
    dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    dnf clean all -y

