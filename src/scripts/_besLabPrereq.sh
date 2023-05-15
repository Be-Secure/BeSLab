#!/bin/bash

# Check if VirtualBox is installed
if [ "$(which virtualbox)" ]; then
    echo "VirtualBox is already installed"
else
    # Check if the system is using apt or yum package manager
    if [ "$(which apt-get)" ]; then
        sudo apt-get update
        sudo apt-get install virtualbox
    elif [ "$(which yum)" ]; then
        sudo yum install -y virtualbox
    else
        echo "Unsupported package manager"
        exit 1
    fi

    # Verify installation
    if [ "$(which virtualbox)" ]; then
        echo "VirtualBox installation successful"
    else
        echo "VirtualBox installation failed"
        exit 1
    fi
fi
# Check for vagrant instalation . Install it if not installed
if [ "$(which vagrant)" ]; then
    echo "vagrant is already installed"
else
    sudo apt-get update
    sudo apt-get install -y curl gnupg2 software-properties-common
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update
    sudo apt-get install -y vagrant
    echo "Vagrant has been installed."
fi    
# Check for ansible instalation . Install it if not installed
if ! command -v ansible &> /dev/null
then
    echo "Ansible is not installed, installing now..."
    sudo apt-get update
    sudo apt-get install software-properties-common -y
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible -y
    echo "Ansible installed successfully!"
else
    echo "Ansible is already installed"
fi

