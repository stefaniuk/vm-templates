#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_CLEANUP" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]] && exit

yum --assumeyes clean all
rm -rfv \
    /tmp/* \
    /var/tmp/*
