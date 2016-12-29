#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_BASE" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]] && exit

[ -n "$APT_PROXY" ] && echo "Acquire::http { Proxy \"http://${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/00proxy
[ -n "$APT_PROXY_SSL" ] && echo "Acquire::https { Proxy \"https://${APT_PROXY_SSL}\"; };" > /etc/apt/apt.conf.d/00proxy

# fix issue with stdin
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# install packages
apt-get --yes update
apt-get --yes upgrade
apt-get --yes --force-yes --ignore-missing --no-install-recommends install \
    ack-grep \
    curl \
    htop \
    lsof \
    net-tools \
    netcat \
    nfs-common \
    sshpass \
    strace \
    unzip \
    vim \
    wget
