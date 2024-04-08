#!/bin/bash

function __besman_install_sonarqube()
{
    local sast_version artifact_path
    sast_version=$1
    artifact_path=$2
    if [[ -d "$artifact_path/$sast_version" ]]; then
        __besman_echo_yello "Sonarqube found"
    else
        __besman_echo_yello "Downloading $sast_version"
        wget -P "$artifact_path" "https://binaries.sonarsource.com/Distribution/sonarqube/$sast_version.zip"
        __besman_echo_yello "Extracting archive"
        unzip -q "$artifact_path/$sast_version.zip" -d "$artifact_path"
    fi
}

function __besman_uninstall_sonarqube()
{
    local sast_version artifact_path
    sast_version=$1
    artifact_path=$2
    if [[ -d "$artifact_path/$sast_version" ]]; then
        __besman_echo_yello "Removing sonarqube"
        sudo rm -rf "$artifact_path/$sast_version"
    else
        __besman_echo_yello "Sonarqube not found. Nothing to uninstall"
    fi
}