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

    cd .. && rm -rf ./BeSLighthouse-${beslight_ver}


    if [ -d "$HOME/.besman" ];then
      gitlab_user_data_file_path="$HOME/.besman/gitlabUserDetails"
    elif [ -d "$HOME/.bliman" ];then
      gitlab_user_data_file_path="$HOME/.bliman/gitlabUserDetails"
    fi

    if [ -f $gitlab_user_data_file_path ];then
      GITUSER=`cat $gitlab_user_data_file_path | grep "GITLAB_USERNAME:" | awk '{print $2}'`
      GITUSERTOKEN=`cat $gitlab_user_data_file_path | grep "GITLAB_USERTOKEN:" | awk '{print $2}'`
    fi

    beslighthouse_config_path=$beslight_path/src/apiDetailsConfig.json
    sed -i '/"activeTool"/c\"activeTool": "gitlab"' $beslighthouse_config_path
    sed -i "/\"namespace\"/c\"namespace\": \"$GITUSER\"," $beslighthouse_config_path
    sed -i "/\"token\"/c\"token\": \"$GITUSERTOKEN\"," $beslighthouse_config_path
    myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
    sed -i "/\"apiUrl\"/c\"apiUrl\": \"http://$myip:5000\"," $beslighthouse_config_path
    sed -i "/\"gitlabUrl\"/c\"gitlabUrl\": \"http://$myip\"," $beslighthouse_config_path


    which pip

    [[ xx"$?" != xx"0" ]] && sudo apt-get -y install python3-pip

    mkdir -p $BESLAB_DASHBOARD_API_INSTALL_PATH
    
    cd $BESLAB_DASHBOARD_API_INSTALL_PATH

    git clone https://github.com/Be-Secure/beslighthouse-rest-api

    cd beslighthouse-rest-api

    pip install -r requirements.txt

    if [ -f ./blrestapi.sh ];then
	cp ./blrestapi.sh /usr/lib/blrestapi.sh
	chmod +x /usr/lib/blrestapi.sh
	cp ./blrestapi.service /lib/systemd/system/blrestapi.service
	systemctl daemon-reload
	systemctl enable blrestapi.service
	systemctl start blrestapi.service
    else
       flask run --host="0.0.0.0" --port=5000 &
    fi

    PWD=`pwd`
    if [ -d "$HOME/.besman" ];then
        beslighthousedatafile="$HOME/.besman/beslighthousedata"
    elif  [ -d "$HOME/.bliman" ];then
         beslighthousedatafile="$HOME/.bliman/beslighthousedata"
    fi

    if [ ! -z $beslighthousedatafile ];then
       echo "BESLIGHTHOUSE_DIR: $beslight_path" > $beslighthousedatafile
       echo "BESLIGHTHOUSE_API_DIR: $PWD" >>  $beslighthousedatafile 
    fi

    
    cd $beslight_path

    which npm

    [[ xx"$?" == xx"1" ]] && sudo apt-get -y install npm 
 
    npm install --force

    export NODE_OPTIONS=--openssl-legacy-provider

    
    if [ -f ./beslighthouse.sh ];then
       cp beslighthouse.service /lib/systemd/system/beslighthouse.service
       cp beslighthouse.sh /usr/lib/beslighthouse.sh
       chmod +x /usr/lib/beslighthouse.sh
       sudo systemctl daemon-reload
       sudo systemctl enable beslighthouse.service
       sudo systemctl start beslighthouse.service
    else
      npm start &
    fi
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
