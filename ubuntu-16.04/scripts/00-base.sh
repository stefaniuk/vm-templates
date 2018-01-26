#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_BASE" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]] && exit

[ -n "$APT_PROXY" ] && echo "Acquire::http { Proxy \"http://${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/00proxy
[ -n "$APT_PROXY_SSL" ] && echo "Acquire::https { Proxy \"https://${APT_PROXY_SSL}\"; };" > /etc/apt/apt.conf.d/00proxy

# fix issue with stdin
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# turn off sshd DNS lookup to prevent timeout delay
echo "UseDNS no" >> /etc/ssh/sshd_config

# configure locale and timezone
locale-gen "en_GB.UTF-8"
echo "Europe/London" | tee /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# update system
apt-get --yes update
apt-get --yes upgrade
apt-get --yes --ignore-missing --no-install-recommends install \
    curl \
    nfs-common \

# install dotfiles and additional packages
USER_NAME="vagrant"
USER_EMAIL="vagrant@$(hostname)"
curl -sSL https://raw.githubusercontent.com/stefaniuk/dotfiles/master/dotfiles -o - | /bin/bash -s -- \
    --directory=/home/vagrant \
    --user=vagrant \
    --install \
    --config
