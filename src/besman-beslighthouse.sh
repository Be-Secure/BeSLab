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

   __besman_echo_yellow "Installing node 20"
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh > nvm_install.sh
   chmod +x nvm_install.sh
   ./nvm_install.sh 2>&1 | __beslab_log
   source ~/.bashrc 2>&1 | __beslab_log
   installed_node_version=`node -v`
   latest_node_version=`nvm list-remote | grep "Latest LTS: Iron" | awk '{print $1}'`

   nvm install $latest_node_version  2>&1 | __beslab_log
   nvm use $latest_node_version  2>&1 | __beslab_log

   __besman_echo_green "Installed node version is $node_version"

   __besman_echo_yellow "Fetching BesLighthouse version ${beslight_ver} from github Be-Secure namespace."
   [[ ! -d $beslight_path ]] && mkdir -p $beslight_path
   cd $beslight_path 
   curl -sS -LJO https://github.com/Be-Secure/BeSLighthouse/archive/refs/tags/${beslight_ver}.tar.gz 2>&1 | __beslab_log
   tar -xvzf BeSLighthouse-${beslight_ver}.tar.gz 2>&1 | __beslab_log
   cd ./BeSLighthouse-${beslight_ver}
   mv ./* ../
   cd .. && rm -rf ./BeSLighthouse-${beslight_ver}
   __besman_echo_green "Fetched beslighthouse to /opt/beslighthouse"

    if [ -d "$HOME/.besman" ];then
      gitlab_user_data_file_path="$HOME/.besman/gitlabUserDetails"
    elif [ -d "$HOME/.bliman" ];then
      gitlab_user_data_file_path="$HOME/.bliman/gitlabUserDetails"
    fi

    if [ -f $gitlab_user_data_file_path ];then
      GITUSER=`cat $gitlab_user_data_file_path | grep "GITLAB_USERNAME:" | awk '{print $2}'`
      GITUSERTOKEN=`cat $gitlab_user_data_file_path | grep "GITLAB_USERTOKEN:" | awk '{print $2}'`
    fi

    __besman_echo_yellow "configuring beslighthouse datastore path."
    beslighthouse_config_path=$beslight_path/src/apiDetailsConfig.json
    sed -i '/"activeTool"/c\"activeTool": "gitlab"' $beslighthouse_config_path  2>&1 | __beslab_log
    sed -i "/\"namespace\"/c\"namespace\": \"$GITUSER\"," $beslighthouse_config_path 2>&1 | __beslab_log
    sed -i "/\"token\"/c\"token\": \"$GITUSERTOKEN\"" $beslighthouse_config_path 2>&1 | __beslab_log
    myip="$(dig +short myip.opendns.com @resolver1.opendns.com)" 2>&1 | __beslab_log
    sed -i "/\"apiUrl\"/c\"apiUrl\": \"http://$myip:5000\"," $beslighthouse_config_path 2>&1 | __beslab_log
    sed -i "/\"gitLabUrl\"/c\"gitLabUrl\": \"http://$myip\"," $beslighthouse_config_path 2>&1 | __beslab_log


    __besman_echo_yellow "Installing pip if not installed already"
    which pip
    [[ xx"$?" != xx"0" ]] && sudo apt-get -y install python3-pip 2>&1 | __beslab_log

    __besman_echo_yellow "Installing proxy for beslighthouse..."
    mkdir -p $BESLAB_DASHBOARD_API_INSTALL_PATH 2>&1 | __beslab_log
    cd $BESLAB_DASHBOARD_API_INSTALL_PATH
    git clone https://github.com/Be-Secure/beslighthouse-rest-api 2>&1 | __beslab_log
    cd beslighthouse-rest-api 
    pip install -r requirements.txt 2>&1 | __beslab_log
    
    if [ -f ./blrestapi.sh ];then
	__besman_echo_yellow "Strating beslighthouse proxy service ..."    
	cp ./blrestapi.sh /usr/lib/blrestapi.sh 2>&1 | __beslab_log
	chmod +x /usr/lib/blrestapi.sh 2>&1 | __beslab_log
	cp ./blrestapi.service /lib/systemd/system/blrestapi.service 2>&1 | __beslab_log
	systemctl daemon-reload 2>&1 | __beslab_log
	systemctl enable blrestapi.service 2>&1 | __beslab_log
	systemctl start blrestapi.service 2>&1 | __beslab_log

	if [ systemctl is-active --quiet "blrestapi.service" ];then
          __besman_echo_green "Service beslighthouse proxy started successfully."
        else
          __besman_echo_red"   Beslighthouse proxy service failed to start."
          __besman_echo_red "   Check the service using \"systemctl status blrestapi.service\""
          __besman_echo_red "   Start besdlighthouse proxy manually by following the below steps:"
          __besman_echo_red "       cd /opt/beslighthouse-rest-api"
          __besman_echo_red "       flask run --host="0.0.0.0" --port=5000 &"
	  return 1

        fi

	__besman_echo_green "beslighthouse proxy service is started ..."
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

    __besman_echo_yellow "Installing npm if not installed already ..."
    cd $beslight_path
    which npm
    [[ xx"$?" != xx"0" ]] && sudo apt-get -y install npm 2>&1 | __beslab_log

    __besman_echo_yellow "Installing beslighthouse dependencies ..."
    npm install 2>&1 | __beslab_log
    #export NODE_OPTIONS=--openssl-legacy-provider

    if [ -f ./beslighthouse.sh ];then
       __besman_echo_yellow "setting up beslighthouse service ..." 	    
       cp beslighthouse.service /lib/systemd/system/beslighthouse.service 2>&1 | __beslab_log
       cp beslighthouse.sh /usr/lib/beslighthouse.sh 2>&1 | __beslab_log
       chmod +x /usr/lib/beslighthouse.sh 2>&1 | __beslab_log
       sudo systemctl daemon-reload 2>&1 | __beslab_log
       sudo systemctl enable beslighthouse.service 2>&1 | __beslab_log
       sudo systemctl start beslighthouse.service 2>&1 | __beslab_log
       __besman_echo_green "Beslighthouse service is set ..."
       __besman_echo_yellow "Starting beslighthouse service ..."

       sleep 100s

       if [ systemctl is-active --quiet "beslighthouse.service" ];then
          __besman_echo_green "Service beslighthouse started successfully."
       else
          __besman_echo_red"   Beslighthouse service failed to start."
	  __besman_echo_red "   Check the service using \"systemctl status beslighthouse.service\""
          __besman_echo_red "   Start besdlighthouse manually by following the below steps:"
	  __besman_echo_red "       cd /opt/beslighthouse"
	  __besman_echo_red "       npm start &"
	  return 1
       fi
    else
      __besman_echo_yellow "Strating beslighthouse without service ..."	    
      npm start &
      __besman_echo_yellow "Started beslighthouse ..."
    fi
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
