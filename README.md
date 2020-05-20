# Hello Project :D

---

## Table of Contents <a name="table_of_contents"></a>
* [What you need](#prerequisites)
* [Installation of dependencies](#installationdependencies)
* [Directory structure](#structure)
* [Packer deploy](#packerdeploy)
    * [Kickstart](#kickstart)
* [Vagrant deploy](#vagrantdeploy)
    * [Node VM](#nodevm)
* [Ansible playbooks](#ansibleplaybooks)
* [Application deploy](#applicationdeploy)
* [Load test](#loadtest)
* [Processes](#processes)
* [Log parse](#logparse)


## What you need [[Back to contents]](#table_of_contents) <a name="prerequisites"></a>
- [Python](https://www.python.org/) >= 3.7
- [Ansible](https://www.ansible.com/) >= 2.8.4
- [Vagrant](https://www.vagrantup.com/) >= 2.2
- [Packer](https://packer.io/) >= 1.5


## Installation [[Back to contents]](#table_of_contents) <a name="installationdependencies"></a>
```
# Installation process of VirtualBox will not be described

# Install EPEL
sudo yum install epel-release -y

# Install Python
sudo yum install gcc openssl-devel bzip2-devel
wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz
tar xzf Python-3.7.2.tgz
cd Python-3.7.2.tgz
./configure ––enable–optimizations
make altinstall

# Install Ansible
sudo yum install ansible -y

# Install Vagrant
yum install https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.rpm -y

# Install Packer
yum install unzip -y
wget https://releases.hashicorp.com/packer/1.5.4/packer_1.5.4_linux_amd64.zip
unzip packer_1.5.4_linux_amd64.zip
mv packer /usr/bin
rm -f packer_1.5.4_linux_amd64.zip
yum remove unzip -y
```


## Directory structure [[Back to contents]](#table_of_contents) <a name="structure"></a>
```
./
├── app_deploy/                                     # Python application
│   └── app_deploy.py                               # Main python
│   └── module_ansible.py                           # Ansible module
│   └── module_log.py                               # Log module
│   └── requirements.txt                            # Dependencies
├── boxes/                                          # Boxes generated with Packer
├── files/                                          # Additional files
│   └── helloproject_key                            # Private key for SSH
│   └── helloproject_key.pub                        # Public key for SSH
├── http/                                           # Files to get in boot process
│   └── helloproject_ks.cfg                         # Kickstart file
├── iso/                                            # Stored ISO and checksum files
│   └── CentOS-7-x86_64-Minimal-1908_sha256sum.txt  # File with checksum CentOS version 1908
├── hello_project_node/                             # Node VM data
│   └── Vagrantfile                                 # Vagrantfile to Node VM
├── packer_templates/                               # Packer templates
│   └── helloproject_centos_virtualbox.json         # JSON file to builder VirtualBox
│   └── helloproject_centos_vmware.json             # JSON file to builder VMware
├── playbooks/                                      # Playbooks
│   └── files/                                      # Files to playbooks
│       └── app.js                                  # NodeJS application
│       └── helloproject.crt                        # Certificate to Nginx
│       └── helloproject.key                        # Private key to Nginx
│       └── nginx.conf                              # Nginx file conf
│       └── package.json                            # Package file to NodeJS application
│       └── log_parse.sh                            # Script to parse the access log
│   └── templates/                                  # Templates to playbooks
│       └── node_app_service.j2                     # Jinja file to Node systemd service
│       └── node_app_target.j2                      # Jinja file to Node systemd target
│       └── node_proxy_nginx.j2                     # Jinja file to proxy reverse conf
│   └── app_deploy.yaml                             # App deploy
│   └── nginx.yaml                                  # Nginx deploy
│   └── node_deploy.yaml                            # Node deploy
│   └── node_testing.yaml                           # Testing Node application
├── scripts/                                        # Scan files
│   └── builder_tools.sh                            # Install VMwareTools or VBoxGuestAdditions
│   └── clean.sh                                    # Clean files after Packer deploy
│   └── load_test.py                                # Load test script
├── deploy.sh                                       # Deploy all tasks
```


## Packer deploy [[Back to contents]](#table_of_contents) <a name="packerdeploy"></a>
Responsible for creating the virtual machine, installing it using Kickstart and generating the box for Vangrat.

#### Kickstart [[Back to contents]](#table_of_contents) <a name="kickstart"></a>
Responsible for setting the machine installation settings, creating the user and the settings for SSH access.

#### User
- helloproject

#### Password
- helloproject

#### Root password
- helloproject

## Vagrant deploy [[Back to contents]](#table_of_contents) <a name="vagrantdeploy"></a>
Responsible for deploying the virtual machine and calling the playbook nodevm_deploy.yaml for configuration.

#### Node VM [[Back to contents]](#table_of_contents) <a name="nodevm"></a>
Machine responsible for running Nginx and the NodeJS application.

#### Path NodeJS application
- /home/helloproject/node_app

## Ansible playbooks [[Back to contents]](#table_of_contents) <a name="ansibleplaybooks"></a>

#### app_deploy.yaml
Responsible for deploying the application and importing the test task, perform the rollback if necessary as well.

#### nodevm_deploy.yaml
Responsible for making the settings on the virtual machine.

#### node_testing.yaml
Responsible for performing tests on the application after deploy.

#### nginx.yaml
Responsible for configuring Nginx.

### Jinja Templates

#### node_app_service.j2
Template for /etc/systemd/systemd/node_app@XXXX.service, this is responsible for starting the NodeJS application.

#### node_app_target.j2
Template for /etc/systemd/system/node_app.target, this is responsible for managing node_app services.

#### node_proxy_nginx.j2
Template for /etc/nginx/conf.d/node.conf, this has the reverse proxy settings. 


## Application deploy [[Back to contents]](#table_of_contents) <a name="applicationdeploy"></a>
This will be responsible for receiving the request for the deployment request and executing the playbook.

#### Start application
- screen -S "app_deploy" -dm python3.7 app_deploy/app_deploy.py

#### Request headers
- Key-Deploy - Security key for authorization deploy.
- Application-Deploy - Name of the application to deploy.
- Server-Deploy - IP of the server to execute playbook.

#### Example request (Simulation of a webhook)
```
curl -i -X POST http://127.0.0.1:5000/app_deploy \
    -H "Key-Deploy: key_security" \
    -H "Application-Deploy: node_app" \
    -H "Server-Deploy: 10.0.50.10"
```


## Load test [[Back to contents]](#table_of_contents) <a name="loadtest"></a>
This is responsible for carrying out the load test and creating calls for random url.


```
usage: load_test.py [-h] [-t NUMBER_THREADS] [-r NUMBER_REQUESTS] -a APP_HOST
                    -i SERVER_IP --load --random

optional arguments:
  -h, --help          show this help message and exit
  -t NUMBER_THREADS   number of threads
  -r NUMBER_REQUESTS  number of requests for threads
  -a APP_HOST         application virtualhost
  -i SERVER_IP        server ip
  --load              action to test load
  --random            action to generate access in random path
  ```

#### Example to generate random access

```python3.7 scripts/load_test.py -a helloproject.com -i 10.0.50.10 --random```

#### Example to load test

```python3.7 scripts/load_test.py -a helloproject.com -i 10.0.50.10 -t 50 -r 500 --load```


## Load test [[Back to contents]](#table_of_contents) <a name="loadtest"></a>
Systemd is responsible for monitoring the NodeJS and Nginx application processes, ensuring that if they stop, the start is performed again. The option Restart=always has been added to the services.

## Log parse [[Back to contents]](#table_of_contents) <a name="logparse"></a>
The entry below was created in the contrab to run the log report.

```
#Ansible: execute log_parse.sh
0 22 * * * /usr/bin/log_parse.sh
```
