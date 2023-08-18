#!/bin/bash

function __besman_install_maven_artifact_repo()
{
    __besman_install_java || return 1
    __besman_echo_yelllow "Installing public artifact repo: maven"
    sudo apt update
    sudo apt install maven -y
}

function __besman_uninstall_maven_artifact_repo()
{
    if [[ -n $(which mvn) ]]; then
        __besman_echo_yelllow "Uninstalling maven"
        sudo apt purge --autoremove maven -y
    else
        __besman_echo_yelllow "Maven not found. Nothing to uninstall"
    fi
}