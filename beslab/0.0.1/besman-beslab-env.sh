#!/bin/bash
function __sanity_check ()
{
	local mandatory_env_variables=(
BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL
BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION
BESLAB_CODECOLLAB_DATASTORES
BESLAB_DASHBOARD_TOOL
BESLAB_DASHBOARD_RELEASE_VERSION
BESMAN_LAB_TYPE
BESMNA_LAB_NAME
)

local undefined_vars=()

for env_var in "${mandatory_env_variables[@]}"
do
   if [ -z "${!env_var}" ];then
	undefined_vars+=("$env_var")
   fi
done


if [ ! -z $undefined_vars ];then
     echo ""
     echo "ERROR:"
     echo "Following variables are not defined in Genesis file. Define them and retry."
     echo ""
     for und_var in "${undefined_vars[@]}"
     do
        echo "$und_var"
     done
     echo "Exiting ..."
     echo ""
     exit 1
fi


}

function __besman_install()
{   
    __sanity_check

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
        __besman_install_maven_artifact_repo
    elif [[ ( -n "$BESLAB_ARTIFACT_REPO_SCOPE" ) && ( "$BESLAB_ARTIFACT_REPO_SCOPE" == "private" ) ]]; then 
        __besman_install_jfrog
    fi
    if [[ ( -n "$BESLAB_LICENSE_COMPLIANCE" ) && ( "$BESLAB_LICENSE_COMPLIANCE" == "fossology" ) ]]; then
        __besman_install_fossology
    fi
    if [[ ( -n "$BESLAB_SBOM" ) && ( "$BESLAB_SBOM" == "spdx-sbom-generator" ) ]]; then
        __besman_install_spdx-sbom-generator "$BESLAB_ARTIFACT_REPO_SCOPE" "$BESLAB_SBOM_VERSION"
    fi
    if [[ ( -n "$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL" ) && ( "$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL" == "gitlab-ce") ]]; then
        __besman_install_gitlab
    fi
    if [[ ( -n "$BESLAB_DASHBOARD_TOOL" ) && "$BESLAB_DASHBOARD_TOOL" == "beslighthouse" ]]; then
        __besman_install_beslighthouse
    fi
}

function __besman_uninstall()
{
    __besman_uninstall_java || return 1
    if [[ $BESLAB_SAST == "sonarqube" ]]; then
        __besman_uninstall_sonarqube "$BESLAB_SAST_VERSION" "$BESLAB_ARTIFACT_PATH"
    fi
    if echo "$BESLAB_BES_TOOL" | grep -q "BeS-dev-kit"
    then
        __besman_uninstall_bes-dev-kit
    fi
    if [[ ( -n "$BESLAB_PACKAGE_MANAGER" ) && ( "$BESLAB_PACKAGE_MANAGER_SCOPE" == "public" ) ]]; then
        __besman_install_package_managers
    fi
    if [[ ( -n "$BESLAB_ARTIFACT_REPO_SCOPE" ) && ( "$BESLAB_ARTIFACT_REPO_SCOPE" == "public" ) ]]; then
        __besman_uninstall_maven_artifact_repo
    elif [[ ( -n "$BESLAB_ARTIFACT_REPO_SCOPE" ) && ( "$BESLAB_ARTIFACT_REPO_SCOPE" == "private" ) ]]; then 
        __besman_uninstall_jfrog
    fi
    if [[ ( -n "$BESLAB_LICENSE_COMPLIANCE" ) && ( "$BESLAB_LICENSE_COMPLIANCE" == "fossology" ) ]]; then
        __besman_uninstall_fossology
    fi
    if [[ ( -n "$BESLAB_SBOM" ) && ( "$BESLAB_SBOM" == "spdx-sbom-generator" ) ]]; then
        __besman_uninstall_spdx-sbom-generator "$BESLAB_ARTIFACT_REPO_SCOPE" "$BESLAB_SBOM_VERSION"
    fi
    if [[ ( -n "$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL" ) && ( "$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL" == "gitlab-ce") ]]; then
       __besman_uninstall_gitlab
    fi
    if [[ ( -n "$BESLAB_DASHBOARD_TOOL" ) && "$BESLAB_DASHBOARD_TOOL" == "beslighthouse" ]]; then
        __besman_uninstall_beslighthouse
    fi
}


