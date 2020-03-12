#!/bin/bash

set -e
set -x

# install dependencies
sudo yum -y install perl
sudo yum -y install net-tools
sudo yum -y install make
sudo yum -y install gcc
sudo yum -y install kernel-devel
sudo yum -y install kernel-headers

# check builder type
if [ "$PACKER_BUILDER_TYPE" == "virtualbox-iso" ]; then
  # mount and install guest additions
  sudo mkdir /mnt/virtualbox
  sudo mount -o loop,ro /home/$HELLOPROJECTUSER/VBoxGuestAdditions.iso /mnt/virtualbox
  sudo /mnt/virtualbox/./VBoxLinuxAdditions.run
  # clean files
  sudo umount /mnt/virtualbox
  sudo rm -rf /mnt/virtualbox
  rm -f /home/$HELLOPROJECTUSER/VBoxGuestAdditions.iso
else
  # exit with error if builder unidentified
  exit 1
fi
