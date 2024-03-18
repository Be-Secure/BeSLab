#!/bin/bash
function __besman_install_beslighthouse()
{
    local gitlab_version database_path

   __besman_echo_yellow "Install Node 20"

   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh > nvm_install.sh

   chmod +x nvm_install.sh

   ./nvm_install.sh

   source ~/.bashrc

   node_version=`node -v`
   __besman_echo_yellow "Installed node version is $node_version"

   nvm install v20.11.1

    __besman_echo_yellow "Fetch BesLighthouse"

    [[ ! -d /opt/beslighthouse ]] && mkdir -p /opt/beslighthouse && cd /opt/beslighthouse

    curl -LJO https://github.com/Be-Secure/BeSLighthouse/archive/refs/tags/0.16.2.tar.gz
    
    tar -xvzf BeSLighthouse-0.16.2.tar.gz

    cd ./BeSLighthouse-0.16.2

    which npm

    [[ xx"$?" == xx"1" ]] && sudo apt-get -y install npm 
 
    npm install --force

    export NODE_OPTIONS=--openssl-legacy-provider

    npm start &
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
