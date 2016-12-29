#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_VIRTUALBOX" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]] && [ $PACKER_BUILDER_TYPE != "virtualbox" ] exit

# install guest additions
mount -o loop /home/${SSH_USERNAME}/VBoxGuestAdditions.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -fv /home/${SSH_USERNAME}/{VBoxGuestAdditions.iso,.vbox_version}
