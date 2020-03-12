# Hello Project

---

## Table of Contents <a name="table_of_contents"></a>
* [What you need](#prerequisites)
* [Installation of dependencies](#installationdependencies)
* [Directory structure](#structure)
* [Work diagram](#workdiagram)
* [Packer deploy](#packerdeploy)
    * [Builders](#packerbuilders)
    * [Templates](#packertemplates)
    * [Kickstart](#kickstart)
* [Vagrant deploy](#vagrantdeploy)
    * [Node](#nodevm)
    * [Puppet server](#puppetservervm)
* [Ansible playbooks](#ansibleplaybooks)
* [Application deploy](#applicationdeploy)
    * [Deploy diagram](#deploydiagram)


## What you need [[Back to contents]](#table_of_contents) <a name="prerequisites"></a>
- [Python](https://www.python.org/) >= 3.7
- [Ansible](https://www.ansible.com/) >= 2.8.4
- [Vagrant](https://www.vagrantup.com/) >= 2.2
- [Packer](https://packer.io/) >= 1.5


## Installation [[Back to contents]](#table_of_contents) <a name="installationdependencies"></a>
```
# Installation process of VirtualBox or VMware will not be described

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
├── hello_project_puppet/                           # Puppet VM data
│   └── Vagrantfile                                 # Vagrantfile to Puppet Server VM
├── packer_templates/                               # Packer templates
│   └── helloproject_centos_virtualbox.json         # JSON file to builder VirtualBox
│   └── helloproject_centos_vmware.json             # JSON file to builder VMware
├── playbooks/                                      # Playbooks
│   └── files/                                      # Files to playbooks
│       └── puppet_agent.conf                       # File configuration for Puppet agent
│   └── templates/                                  # Templates to playbooks
│       └── node_app_service.j2                     # Jinja file to Node systemd service
│       └── node_app_target.j2                      # Jinja file to Node systemd target
│   └── nginx.yaml                                  # Nginx deploy
│   └── node_deploy.yaml                            # Node deploy
│   └── puppet.yaml                                 # Puppet install
│   └── puppetserver_deploy.yaml                    # Pupper server deploy
├── scripts/                                        # Scan files
│   └── builder_tools.sh                            # Install VMwareTools or VBoxGuestAdditions
│   └── clean.sh                                    # Clean files after Packer deploy
├── deploy.sh                                       # Deploy all tasks
```


## Working diagram [[Back to contents]](#table_of_contents) <a name="workdiagram"></a>

![alt text](https://github.com/elianmarks/ "Working diagram")

## Packer deploy [[Back to contents]](#table_of_contents) <a name="packerdeploy"></a>


#### Builders [[Back to contents]](#table_of_contents) <a name="packerbuilders"></a>


#### Templates [[Back to contents]](#table_of_contents) <a name="packertemplates"></a>


#### Kickstart [[Back to contents]](#table_of_contents) <a name="kickstart"></a>


## Vagrant deploy [[Back to contents]](#table_of_contents) <a name="vagrantdeploy"></a>


#### Node [[Back to contents]](#table_of_contents) <a name="nodevm"></a>


#### Puppet server [[Back to contents]](#table_of_contents) <a name="puppetservervm"></a>


## Ansible Playbooks Tests [[Back to contents]](#table_of_contents) <a name="ansibleplaybooks"></a>


## Application deploy [[Back to contents]](#table_of_contents) <a name="applicationdeploy"></a>


#### Deploy diagram [[Back to contents]](#table_of_contents) <a name="deploydiagram"></a>