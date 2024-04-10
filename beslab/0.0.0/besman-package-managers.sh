#!/bin/bash

function __besman_install_package_managers()
{
    __besman_echo_yellow "Installing npm gradle maven and pip"
    sudo apt update
    sudo apt install nodejs npm gradle maven python3-pip
}

function __besman_uninstall_package_managers()
{
    __besman_echo_yellow "Uninstalling npm gradle maven and pip"
    sudo apt update
    sudo apt purge --autoremove nodejs npm gradle maven python3-pip
}


