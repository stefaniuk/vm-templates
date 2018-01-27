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

# disabling screen blanking
if [ -d /etc/xdg/autostart/ ]; then
    NODPMS_CONFIG=/etc/xdg/autostart/nodpms.desktop
    echo "[Desktop Entry]" >> $NODPMS_CONFIG
    echo "Type=Application" >> $NODPMS_CONFIG
    echo "Exec=xset -dpms s off s noblank s 0 0 s noexpose" >> $NODPMS_CONFIG
    echo "Hidden=false" >> $NODPMS_CONFIG
    echo "NoDisplay=false" >> $NODPMS_CONFIG
    echo "X-GNOME-Autostart-enabled=true" >> $NODPMS_CONFIG
    echo "Name[en_US]=nodpms" >> $NODPMS_CONFIG
    echo "Name=nodpms" >> $NODPMS_CONFIG
    echo "Comment[en_US]=" >> $NODPMS_CONFIG
    echo "Comment=" >> $NODPMS_CONFIG
fi
