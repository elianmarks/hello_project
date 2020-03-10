#!/bin/bash

set -e
set -x

sudo rpm -ivh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm

if [ "$SERVERTYPE" == "node" ]; then
    sudo yum install -y puppet-agent
    sudo sed -i 's/\/sbin:\/bin:\/usr\/sbin:\/usr\/bin/\/sbin:\/bin:\/usr\/sbin:\/usr\/bin:\/opt\/puppetlabs\/bin/' /etc/sudoers
    sudo rm -f /etc/puppetlabs/puppet/puppet.conf
    sudo cp /tmp/puppet.conf /etc/puppetlabs/puppet/
    sudo sed -i -e "\$a# puppet server config" /etc/hosts
    sudo sed -i -e "\$a$PUPPETSERVER\tpuppet.linx.com" /etc/hosts
    # sudo puppet agent --enable
fi
