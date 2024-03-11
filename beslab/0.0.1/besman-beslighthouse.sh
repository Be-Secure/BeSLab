#!/bin/bash
function __besman_install_beslighthouse()
{
    local gitlab_version database_path

    __besman_echo_yellow "Fetch BesLighthouse"

    [[ ! -d /opt/beslighthouse ]] && mkdir -p /opt/beslighthouse && cd /opt/beslighthouse

    curl -LJO https://github.com/Be-Secure/BeSLighthouse/archive/refs/tags/0.16.2.tar.gz
    
    tar -xvzf BeSLighthouse-0.16.2.tar.gz

    cd ./BeSLighthouse-0.16.2

    which npm

    if [ xx"$?" == xx"1" ]];then
       sudo apt-get -y install npm
    fi
 
    npm install --force

    export NODE_OPTIONS=--openssl-legacy-provider

    npm start &
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
