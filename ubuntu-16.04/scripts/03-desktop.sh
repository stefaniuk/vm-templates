#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_DESKTOP" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]] && exit

if [ $PACKER_BUILDER_TYPE != "virtualbox" ]; then
    apt-get --yes --ignore-missing --no-install-recommends install \
        virtualbox-guest-x11
fi
apt-get --yes --ignore-missing --no-install-recommends install \
    ubuntu-desktop

GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf
mkdir -p $(dirname $GDM_CUSTOM_CONFIG)
echo "[daemon]" >> $GDM_CUSTOM_CONFIG
echo "AutomaticLoginEnable=True" >> $GDM_CUSTOM_CONFIG
echo "AutomaticLoginEnable=$SSH_USERNAME" >> $GDM_CUSTOM_CONFIG
LIGHTDM_CONFIG=/etc/lightdm/lightdm.conf
echo "[SeatDefaults]" >> $LIGHTDM_CONFIG
echo "autologin-user=$SSH_USERNAME" >> $LIGHTDM_CONFIG
