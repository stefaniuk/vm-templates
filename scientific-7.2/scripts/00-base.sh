#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_BASE" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]] && exit

# turn off sshd DNS lookup to prevent timeout delay
echo "UseDNS no" >> /etc/ssh/sshd_config
