#!/bin/bash

function __besman_install_beslab-env()
{
    __besman_install_java || return 1
    if [[ $BESLAB_SBOM == "spdx-sbom-generator" ]]; then
        __besman_install_spdx-sbom-generator "$BESLAB_SBOM_VERSION" "$BESLAB_ARTIFACT_PATH"
    fi
    
    if [[ $BESLAB_SAST == "sonarqube" ]]; then
        __besman_install_sonarqube "$BESLAB_SAST_VERSION" "$BESLAB_ARTIFACT_PATH"
    fi
    if echo "$BESLAB_BES_TOOL" | grep -q "BeS-dev-kit"
    then
        __besman_install_bes-dev-kit
    fi
    if [[ ( -n "$BESLAB_PACKAGE_MANAGER" ) && ( "$BESLAB_PACKAGE_MANAGER_SCOPE" == "public" ) ]]; then
        __besman_install_package_managers
    fi
    if [[ ( -n "$BESLAB_ARTIFACT_REPO_SCOPE" ) && ( "$BESLAB_ARTIFACT_REPO_SCOPE" == "public" ) ]]; then
        __besman_install_public_artifact_repo
    elif [[ ( -n "$BESLAB_ARTIFACT_REPO_SCOPE" ) && ( "$BESLAB_ARTIFACT_REPO_SCOPE" == "private" ) ]]; then 
        __besman_install_jfrog
    fi
    if [[ ( -n "$BESLAB_LICENSE_COMPLIANCE" ) && ( "$BESLAB_LICENSE_COMPLIANCE" == "fossology" ) ]]; then
        __besman_install_fossology
    fi
}



