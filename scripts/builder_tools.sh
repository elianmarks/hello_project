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
if [ "$PACKER_BUILDER_TYPE" == "vmware-iso" ]; then
  # mount and install tools
  sudo mkdir /mnt/vmware
  sudo mount -o loop,ro /home/$LINXUSER/linux.iso /mnt/vmware
  mkdir /tmp/vmware
  tar zxf /mnt/vmware/VMwareTools-*.tar.gz -C /tmp/vmware
  sudo /tmp/vmware/vmware-tools-distrib/vmware-install.pl --default --force-install
  # clean files
  rm -rf /tmp/vmware
  sudo umount /mnt/vmware
  sudo rm -rf /mnt/vmware
  rm -f /home/$LINXUSER/linux.iso
  # config tools
  sudo /usr/bin/vmware-config-tools.pl --default --skip-stop-start
elif [ "$PACKER_BUILDER_TYPE" == "virtualbox-iso" ]; then
  # mount and install guest additions
  sudo mkdir /mnt/virtualbox
  sudo mount -o loop,ro /home/$LINXUSER/VBoxGuestAdditions.iso /mnt/virtualbox
  sudo /mnt/VBoxLinuxAdditions.run
  # clean files
  sudo umount /mnt/virtualbox
  sudo rm -rf /mnt/virtualbox
  rm -f /home/$LINXUSER/VBoxGuestAdditions.iso
else
  # exit with error if builder unidentified
  exit 1
fi
