#!/bin/bash

function __besman_install_package_managers()
{
    if echo "$BESLAB_PACKAGE_MANAGER" | grep -q "npm"
    then
        __besman_install_npm
    fi
    if echo "$BESLAB_PACKAGE_MANAGER" | grep -q "maven"
    then
        __besman_install_maven
    fi
    if echo "$BESLAB_PACKAGE_MANAGER" | grep -q "gradle"
    then
        __besman_install_gradle
    fi
    if echo "$BESLAB_PACKAGE_MANAGER" | grep -q "pip"
    then
        __besman_install_pip
    fi
}

function __besman_install_npm()
{
    [[ -n $(which npm) ]] && echo "npm found" && return 
    sudo apt update
    sudo apt install nodejs
    sudo apt install npm
}

function __besman_install_maven()
{
    [[ -n $(which maven) ]] && echo "maven found" && return 
    sudo apt update
    sudo apt install maven
}

function __besman_install_gradle()
{
    [[ -n $(which gralde) ]] && echo "gralde found" && return 
    sudo apt update
    sudo apt install gralde
}

function __besman_install_pip()
{
    [[ -n $(which pip) ]] && echo "pip found" && return 
    sudo apt update
    sudo apt install python3-pip
}