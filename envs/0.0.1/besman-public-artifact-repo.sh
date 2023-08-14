#!/bin/bash

function __besman_install_public_artifact_repo()
{
    __besman_install_java || return 1
    __besman_install_maven
}