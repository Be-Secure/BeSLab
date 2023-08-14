#!/bin/bash
function __besman_install_spdx-sbom-generator()
{
    local sbom_version artifact_path
    sbom_version=$1
    artifact_path=$2
    if [[ -f "$artifact_path/spdx-sbom-generator" ]]; then
        echo "spdx-sbom-generator found"
        return
    else
        echo "Downloading spdx-sbom-generator $sbom_version"
        wget -P "$artifact_path" "https://github.com/opensbom-generator/spdx-sbom-generator/releases/download/$sbom_version/spdx-sbom-generator-$sbom_version-linux-amd64.tar.gz"
        tar -xzf "$artifact_path/spdx-sbom-generator-$sbom_version-linux-amd64.tar.gz" -C "$artifact_path"
    fi

}