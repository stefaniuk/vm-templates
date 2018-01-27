#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_VAGRANT" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]] && exit

# SEE: https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

# install key
mkdir -p /home/$SSH_USERNAME/.ssh
echo "$SSH_KEY" > /home/$SSH_USERNAME/.ssh/authorized_keys
chmod 700 /home/$SSH_USERNAME/.ssh
chmod 600 /home/$SSH_USERNAME/.ssh/authorized_keys
chown -R $SSH_USERNAME:$SSH_USERNAME /home/$SSH_USERNAME/.ssh

# configure user
echo "Defaults:$SSH_USERNAME !"'requiretty' > /etc/sudoers.d/vagrant
echo "$SSH_USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 440 /etc/sudoers.d/vagrant
