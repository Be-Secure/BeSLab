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

# function __besman_install_npm()
# {
#     [[ -n $(which npm) ]] && __besman_echo_yellow "npm found" && return 
#     __besman_echo_yellow "Installing npm"
#     sudo apt update
#     sudo apt install nodejs
#     sudo apt install npm
# }

# function __besman_install_maven()
# {
#     [[ -n $(which maven) ]] && __besman_echo_yellow "maven found" && return 
#     __besman_echo_yellow "Installing maven"
#     sudo apt update
#     sudo apt install maven
# }

# function __besman_install_gradle()
# {
#     [[ -n $(which gralde) ]] && __besman_echo_yellow "gralde found" && return 
#     __besman_echo_yellow "Installing gradle"
#     sudo apt update
#     sudo apt install gralde
# }

# function __besman_install_pip()
# {
#     [[ -n $(which pip) ]] && __besman_echo_yellow "pip found" && return 
#     __besman_echo_yellow "Installing pip"
#     sudo apt update
#     sudo apt install python3-pip
# }
