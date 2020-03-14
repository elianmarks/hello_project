#!/bin/bash

# create box
echo "execute packer build"
sleep 2
packer build packer_templates/helloproject_centos_virtualbox.json

# add box in vagrant
echo "add box in vagrant"
sleep 2
vagrant box add --name "helloproject-centos" boxes/centos-7.7.1908-x86_64-virtualbox.box

# up virtual machine
echo "execute vagrant up"
sleep(2)
cd helloproject_node_deploy && vagrant up && cd ..

# testing application
echo "testing app"
sleep(2)
curl -ks -i https://10.0.50.10 -H "Host: helloproject.com"

# install python libraries
echo "install dependencies"
sleep(2)
python3.7 -m pip install -r app_deploy/requirements.txt

# start app_deploy
echo "start app_deploy"
sleep(2)
screen -S "app_deploy" -dm python3.7 app_deploy/app_deploy.py

# deploy new application
echo "change app to 02"
sleep(2)
sed -i 's/Hello World/& 02/' playbooks/files/app.js

# send request deploy to app_deploy
echo "request to deploy"
sleep(2)
curl -i -X POST http://127.0.0.1:5000/app_deploy \
    -H "Key-Deploy: key_security" \
    -H "Application-Deploy: node_app" \
    -H "Server-Deploy: 10.0.50.10"

# change package.json to playbook install new dependencies
echo "change package.json"
sleep(2)
sed -i 's/\"express\": \"\^4.17.1\"/&,\'$'\n\t\"request\": \"~2.30.0\"/' playbooks/files/package.json

# deploy new application
echo "change app to 03"
sleep(2)
sed -i 's/Hello World/& 03/' playbooks/files/app.js

# send request deploy to app_deploy
echo "request to deploy"
sleep(2)
curl -i -X POST http://127.0.0.1:5000/app_deploy \
    -H "Key-Deploy: key_security" \
    -H "Application-Deploy: node_app" \
    -H "Server-Deploy: 10.0.50.10"

# generate random access
echo "generate random access"
sleep(2)
python3.7 scripts/load_test.py -a helloproject.com -i 10.0.50.10 --random

# load test with 50 threads and 1000 request for threads
echo "load test with 50 threads and 1000 request for threads"
sleep(2)
python3.7 scripts/load_test.py -a helloproject.com -i 10.0.50.10 -t 50 -r 1000 --load