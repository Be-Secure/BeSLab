#!/bin/bash

function __besman_install_fossology()
{
 __besman_install_docker || return 1
 __besman_echo_yellow "Pulling fossology image"
 docker pull fossology/fossology
}

function __besman_install_docker()
{
    __besman_echo_yellow "Installing docker"
    sudo apt update
    sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update && sudo apt -y install docker-ce
    [[ "$?" != "0" ]] && echo "Something went wrong" && return 1
    sudo usermod -aG docker "$USER"

}

function __besman_uninstall_fossology()
{
    local container_id
    container_id=$(docker ps | grep "fossology" | cut -d " " -f 1)
    __besman_echo_yellow "Stopping docker image"
    docker stop "$container_id"
    __besman_echo_yellow "Removing docker image"
    docker rm "$container_id"
}