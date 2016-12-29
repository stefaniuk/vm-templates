#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_CLEANUP" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]] && exit

rm -rfv \
    /etc/apt/apt.conf.d/00proxy \
    /tmp/* \
    /var/cache/apt/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
