#!/bin/bash
function __besman_install_spdx-sbom-generator()
{
    local sbom_version artifact_path
    sbom_version=$1
    artifact_path=$2
    if [[ -f "$artifact_path/spdx-sbom-generator" ]]; then
        __besman_echo_yello "spdx-sbom-generator found"
        return
    else
        __besman_echo_yello "Downloading spdx-sbom-generator $sbom_version"
        wget -P "$artifact_path" "https://github.com/opensbom-generator/spdx-sbom-generator/releases/download/$sbom_version/spdx-sbom-generator-$sbom_version-linux-amd64.tar.gz"
        __besman_echo_yello "Extracting tar"
        tar -xzf "$artifact_path/spdx-sbom-generator-$sbom_version-linux-amd64.tar.gz" -C "$artifact_path"
    fi

}

function __besman_uninstall_spdx-sbom-generator()
{
        
    local sbom_version artifact_path
    sbom_version=$1
    artifact_path=$2
    if [[ -f "$artifact_path/spdx-sbom-generator" ]]; then
        __besman_echo_yello "Removing spdx-sbom-generator"
        rm "$artifact_path/spdx-sbom-generator"
        rm "$artifact_path/spdx-sbom-generator-$sbom_version-linux-amd64.tar.gz"
    else
        __besman_echo_yello "spdx-sbom-generator not installed"
    fi
}