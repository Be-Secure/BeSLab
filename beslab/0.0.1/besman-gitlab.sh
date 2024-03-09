#!/bin/bash

function __besman_install_gitlab()
{
    local gitlab_version database_path
    gitlab_version=$1
    database_path=$2
    #if [[ -d "$artifact_path/$sast_version" ]]; then
    #    __besman_echo_yello "Sonarqube found"
    #else

    __besman_echo_yellow "Updating system"
    sudo apt update
    sudo apt upgrade -y
    __besman_echo_yellow "Install dependencies"
    sudo apt install -y ca-certificates curl openssh-server tzdata
    __besman_echo_yellow "Configure Postfix"
    __besman_echo_yellow "Install Gitlab-CE dependencies"
    sudo apt update
    sudo apt install curl debian-archive-keyring lsb-release ca-certificates apt-transport-https software-properties-common -y
    __besman_echo_yellow "Install Gitlab-CE"
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
    sudo apt update
    sudo apt install gitlab-ce
    __besman_echo_yellow "Install Gitlab-CE"
    #fi
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
