#!/bin/bash

function __besman_install_sonarqube()
{
    local sast_version artifact_path
    sast_version=$1
    artifact_path=$2
    if [[ -d "$artifact_path/$sast_version" ]]; then
        echo "Sonarqube found"
    else
        echo "Downloading $sast_version"
        wget -P "$artifact_path" ""
    fi
}