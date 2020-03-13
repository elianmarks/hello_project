#!/bin/bash

# create box
packer build packer_templates/helloproject_centos_virtualbox.json

# add box in vagrant
vagrant box add --name "helloproject-centos" boxes/centos-7.7.1908-x86_64-virtualbox.box

# up virtual machine
cd helloproject_node_deploy && vagrant up

# testing application
curl -ks -I https://10.0.50.10 -H "Host: helloproject.com"

# install python libraries
python -m pip -r requirements.txt install

# start app_deploy
python app_deploy/app_deploy.py &

# deploy new application
sed -i 's/Hello World/& 02/' playbooks/files/app.js

# send request deploy to app_deploy
curl -I -X POST http://127.0.0.1:5000/app_deploy \
    -H "Key-Deploy: key_security" \
    -H "Application-Deploy: node_app" \
    -H "Server-Deploy: 10.0.50.10"

# change package.json to playbook install new dependencies
sed -i 's/\"express\": \"\^4.17.1\"/&,\'$'\n\"request\": \"~2.30.0\",/' playbooks/files/package.json

# deploy new application
sed -i 's/Hello World/& 03/' playbooks/files/app.js

# send request deploy to app_deploy
curl -I -X POST http://127.0.0.1:5000/app_deploy \
    -H "Key-Deploy: key_security" \
    -H "Application-Deploy: node_app" \
    -H "Server-Deploy: 10.0.50.10"

# load test with 50 threads and 1000 request for threads
python scripts/load_test.py -a helloproject.com -i 10.0.50.10 -t 50 -r 1000