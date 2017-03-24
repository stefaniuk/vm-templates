#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_BASE" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]] && exit

[ -n "$APT_PROXY" ] && echo "Acquire::http { Proxy \"http://${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/00proxy
[ -n "$APT_PROXY_SSL" ] && echo "Acquire::https { Proxy \"https://${APT_PROXY_SSL}\"; };" > /etc/apt/apt.conf.d/00proxy

# fix issue with stdin
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# turn off sshd DNS lookup to prevent timeout delay
echo "UseDNS no" >> /etc/ssh/sshd_config

# install packages
apt-get --yes update
apt-get --yes upgrade
apt-get --yes --force-yes --ignore-missing --no-install-recommends install \
    ack-grep \
    curl \
    htop \
    iotop \
    lsof \
    net-tools \
    netcat \
    nfs-common \
    nmap \
    sshpass \
    strace \
    unzip \
    vim \
    wget

# install dotfiles
USER_NAME="unknown"
USER_EMAIL="unknown"
curl -sSL https://raw.githubusercontent.com/stefaniuk/dotfiles/master/dotfiles -o - | /bin/bash -s -- \
    --directory=/home/vagrant \
    --user=vagrant \
    --install=system-bundle \
    --config=bash
