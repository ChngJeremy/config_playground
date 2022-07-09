#!/bin/bash
# rp.sdcard.sh
# Preparing an SD card with a bootable image for the Raspberry Pi.

# $1 = imagefile name
# $2 = sdcard (device file)
# $3 = partition (number)
# $4 = boot partition (number)
# $5 = root partition (number)
# $6 = swap partition (number)
# $7 = imagefile size
# Otherwise defaults to the defaults, see below.

DEFAULTbs=4M                                 # Block size, 4 mb default.
DEFAULTif="2022-04-04-raspios-bullseye-armhf.img"   # Image file name.
DEFAULTsdcard="/dev/mmcblk0"                 # SD card device file.
ROOTUSER_NAME=root                           # User name for the root account.
E_NOTROOT=81
E_NOIMAGE=82
E_NOSDCARD=83
E_NOPARTITION=84
E_NOBUFFER=85
E_NOBUILTIN=86

username=$(id -nu)                           # Get user name.
if [ "$username" != "$ROOTUSER_NAME" ]
then
  echo "This script must run as root or with root privileges."
  exit $E_NOTROOT
fi

if [ -n "$1" ]                            # If image file name is specified.
then
  if [ -f "$1" ]                            # If image file exists.
  then
    DEFAULTif="$1"
  else
    echo "Image file $1 does not exist."
    exit $E_NOIMAGE
  fi
fi
then
  imagefile="$1"
else    
  imagefile="$DEFAULTif"
fi

if [ -n "$2" ]
then
  sdcard="$2"
else
  sdcard="$DEFAULTsdcard"
fi

if [ -n "$3" ]
then
  partition="$3"
else
  partition="1"
fi

if [ -n "$4" ]
then
  bootpartition="$4"
else
  bootpartition="1"
fi

if [ -n "$5" ]
then
  rootpartition="$5"
else
  rootpartition="2"
fi

if [ -n "$6" ]
then
  swappartition="$6"
else
  swappartition="3"
fi

if [ -n "$7" ]
then
  imagesize="$7"
else
  imagesize="$(stat -c%s "$imagefile")"
fi


if [ ! -e $imagefile ]                    # If image file does not exist.
then
  echo "Image file $imagefile does not exist."
  exit $E_NOIMAGE
fi

echo "Last chance to change your mind!"; echo   
read -s -n1 -p "Hit a key to write $imagefile to $sdcard [Ctl-c to exit]."  # Prompt for confirmation.
echo; echo 


echo "Writing $imagefile to $sdcard ..."
dd bs=$DEFAULTbs if=$imagefile of=$sdcard
echo "Write Done."

exit $?                                 # Exit with last command status.

