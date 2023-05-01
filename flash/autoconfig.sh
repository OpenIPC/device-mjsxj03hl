#!/bin/sh

#
# Set osmem and rmem for default resolution
#

fw_setenv osmem 39M
fw_setenv rmem 25M@0x2700000

#
# Cleaning of the settings partition
#

flash_eraseall -j /dev/mtd4
reboot
