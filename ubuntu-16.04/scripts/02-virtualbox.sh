#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_VIRTUALBOX" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]] && [ $PACKER_BUILDER_TYPE != "virtualbox" ] exit

# install guest packages
apt-get --yes --ignore-missing --no-install-recommends install \
    virtualbox-guest-dkms \
    virtualbox-guest-utils
