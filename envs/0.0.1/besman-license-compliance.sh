#!/bin/bash

function __besman_install_fossology()
{
 __besman_install_docker || return 1
 docker pull fossology/fossology
}

function __besman_install_docker()
{
    echo "Installing docker"
    sudo apt update
    sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update && sudo apt -y install docker-ce
    [[ "$?" != "0" ]] && echo "Something went wrong" && return 1
    sudo usermod -aG docker "$USER"

}