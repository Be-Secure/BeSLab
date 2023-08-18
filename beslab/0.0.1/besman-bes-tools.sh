#!/bin/bash

function __besman_install_bes-dev-kit()
{
    __besman_echo_yellow "Installing bes-dev-kit"
    python3 -m pip install besecure-developer-toolkit
}

function __besman_uninstall_bes-dev-kit()
{
    if [[ -z $(which bes-dev-kit) ]]; then
        __besman_echo_yellow "bes-dev-kit is not installed"
    else
    __besman_echo_yellow "Uninstalling bes-dev-kit"
    python3 -m pip uninstall besecure-developer-toolkit
    fi
}