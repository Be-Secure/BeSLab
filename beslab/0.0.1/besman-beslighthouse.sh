#!/bin/bash
function __besman_install_beslighthouse()
{
    local beslight_ver beslight_path

    if [ ! -z $1 ];then
       beslight_ver=$1
    else
       beslight_ver=$BESLAB_DASHBOARD_RELEASE_VERSION
    fi

    if [ ! -z $2 ];then
       beslight_path=$2
    else
       beslight_path=$BESLAB_DASHBOARD_INSTALL_PATH
    fi

   __besman_echo_yellow "Install Node 20"

   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh > nvm_install.sh

   chmod +x nvm_install.sh

   ./nvm_install.sh

   source ~/.bashrc

   node_version=`node -v`
   __besman_echo_yellow "Installed node version is $node_version"

   nvm install v20.11.1

    __besman_echo_yellow "Fetch BesLighthouse"

    [[ ! -d $beslight_path ]] && mkdir -p $beslight_path && cd $beslight_path 

    curl -LJO https://github.com/Be-Secure/BeSLighthouse/archive/refs/tags/${beslight_ver}.tar.gz
    
    tar -xvzf BeSLighthouse-${beslight_ver}.tar.gz

    cd ./BeSLighthouse-${beslight_ver}

    cp -rf ./* ../

    cd ../ && rm -rf ./BeSLighthouse-${beslight_ver}

    PWD=`pwd`
    if [ -d "$HOME/.besman" ];then
        beslighthousedatafile="$HOME/.besman/beslighthousedata"
    elif  [ -d "$HOME/.bliman" ];then
         beslighthousedatafile="$HOME/.bliman/beslighthousedata"
    fi
    echo "BESLIGHTHOUSE_DIR: $PWD" > $beslighthousedatafile
    
    if [ -f ./beslighthouse.sh ];then
       cp ./beslighthouse.sh /usr/lib/beslighthouse.sh
       chmod +x /usr/lib/beslighthouse.sh

       cp beslighthouse.service /lib/systemd/system/

       sudo systemctl daemon-reload
       sudo systemctl enable beslighthouse.service
    fi

    which npm

    [[ xx"$?" == xx"1" ]] && sudo apt-get -y install npm 
 
    npm install --force

    export NODE_OPTIONS=--openssl-legacy-provider

    
    if [ -f ./beslighthouse.sh ];then
       sudo systemctl start beslighthouse.service
    else
      npm start &
    fi
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
