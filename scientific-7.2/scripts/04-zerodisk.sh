#!/bin/bash
set -ex

[[ ! "$BUILD_SCRIPT_ZERODISK" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]] && exit

dd if=/dev/zero of=/EMPTY bs=1M ||:
rm -fv /EMPTY
