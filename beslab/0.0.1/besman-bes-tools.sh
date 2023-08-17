#!/bin/bash

function __besman_install_bes-dev-kit()
{
    __besman_echo_yellow "Installing bes-dev-kit"
    python3 -m pip install besecure-developer-toolkit
}
