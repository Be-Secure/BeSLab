#!/bin/bash

function __besman_install_java()
{
    local java_version
    [[ -z $BESLAB_JAVA_VERSION ]] && echo "Var BESLAB_JAVA_VERSION should be set" && return 1 
    if [[ -n $(which java) ]]; then
        
        java_version=$(java -version)
        if [[ $java_version == "$BESLAB_JAVA_VERSION" ]]; then
            echo "Java found"
            return
        else
            echo "Uninstalling current java version"
            sudo apt purge --autoremove openjdk-*
            echo "Installing java $BESLAB_JAVA_VERSION"
            sudo apt install openjdk-"$BESLAB_JAVA_VERSION"-jdk
        fi

    else
        sudo apt install openjdk-"$BESLAB_JAVA_VERSION"-jdk

    fi
}
