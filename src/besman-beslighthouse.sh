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

   __besman_echo_yellow "Installing node 20. Please wait ..."
   curl --silent -o nvm_install.sh https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh 2>&1>>$BESLAB_LOG_FILE
   chmod +x nvm_install.sh
   source nvm_install.sh 2>&1 |  __beslab_log
   
   source ~/.bashrc 2>&1>>$BESLAB_LOG_FILE

   export NVM_DIR="$HOME/.nvm"

   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
   
   #installed_node_version=`node -v`
   latest_node_version=`nvm list-remote | grep "Latest LTS: Iron" | awk '{print $1}'`

   nvm install $latest_node_version 2>&1 |  __beslab_log
   #nvm use $latest_node_version

   __besman_echo_green "Installed node version $node_version"

   __besman_echo_yellow "Installing BesLighthouse version ${beslight_ver} from github Be-Secure namespace."
   [[ ! -d $beslight_path ]] && mkdir -p $beslight_path
   cd $beslight_path 
   curl --silent -LJO https://github.com/Be-Secure/BeSLighthouse/archive/refs/tags/${beslight_ver}.tar.gz 2>&1>>$BESLAB_LOG_FILE

   if [ ! -f BeSLighthouse-${beslight_ver}.tar.gz ];then
      __besman_echo_red "Error in downloading the BeSLighthouse version ${beslight_ver}."
      return 1
   fi

   tar -xvzf BeSLighthouse-${beslight_ver}.tar.gz 2>&1>>$BESLAB_LOG_FILE
   cd ./BeSLighthouse-${beslight_ver}
   mv ./* ../
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

    __besman_echo_yellow "Configuring Code Collab tool access for BeSLighthouse ..."
    beslighthouse_config_path=$beslight_path/src/apiDetailsConfig.json
    sed -i '/"activeTool"/c\"activeTool": "gitlab",' $beslighthouse_config_path  2>&1 | __beslab_log
    sed -i "/\"namespace\"/c\"namespace\": \"$GITUSER\"," $beslighthouse_config_path 2>&1 | __beslab_log
    sed -i "/\"token\"/c\"token\": \"$GITUSERTOKEN\"" $beslighthouse_config_path  2>&1 | __beslab_log
    myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
    sed -i "/\"apiUrl\"/c\"apiUrl\": \"http://$myip:5000\"," $beslighthouse_config_path  2>&1 | __beslab_log
    if [ ! -z $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT ]; then
      sed -i "/\"gitLabUrl\"/c\"gitLabUrl\": \"http://$myip:$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT\"," $beslighthouse_config_path  2>&1 | __beslab_log
    else
      sed -i "/\"gitLabUrl\"/c\"gitLabUrl\": \"http://$myip:8081\"," $beslighthouse_config_path  2>&1 | __beslab_log
    fi

    which pip 2>&1>>$BESLAB_LOG_FILE
    [[ xx"$?" != xx"0" ]] && __besman_echo_yellow "Installing pip ..." && sudo apt-get -y install python3-pip 2>&1 | __beslab_log

    __besman_echo_yellow "Installing proxy for BeSLighthouse ..."
    mkdir -p $BESLAB_DASHBOARD_API_INSTALL_PATH| __beslab_log
    cd $BESLAB_DASHBOARD_API_INSTALL_PATH
    git clone --quiet https://github.com/Be-Secure/beslighthouse-rest-api 2>&1>>$BESLAB_LOG_FILE
    cd beslighthouse-rest-api 
    __besman_echo_yellow "Installing dependencies for proxy ..."
    pip install -r requirements.txt 2>&1 |  __beslab_log
    
    if [ -f ./blrestapi.sh ];then
	__besman_echo_yellow "Enabling proxy service ..."    
	cp ./blrestapi.sh /usr/lib/blrestapi.sh | __beslab_log
	chmod +x /usr/lib/blrestapi.sh | __beslab_log
	cp ./blrestapi.service /lib/systemd/system/blrestapi.service | __beslab_log
	systemctl daemon-reload 2>&1 | __beslab_log
	systemctl enable blrestapi.service 2>&1 | __beslab_log
	systemctl start blrestapi.service 2>&1 | __beslab_log

	sleep 10s
        is_active_restapi=`systemctl is-active "blrestapi.service"`
	if [ ${is_active_restapi} == "active" ];then
          __besman_echo_green " ###########  Service BeSLighthouse proxy started successfully. ###########"
        else
          __besman_echo_red"   Beslighthouse proxy service failed to start."
          __besman_echo_red "   Check the service using \"systemctl status blrestapi.service\""
          __besman_echo_red "   Start BeSLighthouse proxy manually by following the below steps:"
          __besman_echo_red "       cd /opt/beslighthouse-rest-api"
          __besman_echo_red "       flask run --host="0.0.0.0" --port=5000 &"
	  #return 1

        fi

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
    #which npm
    #[[ xx"$?" != xx"0" ]] && sudo apt-get -y install npm 2>&1 | __beslab_log
    
    ln -s  $HOME/.nvm/versions/node/${latest_node_version}/bin/node /usr/bin/node 2>&1 | __beslab_log
    ln -s  $HOME/.nvm/versions/node/${latest_node_version}/bin/npm /usr/bin/npm 2>&1 | __beslab_log
    
    __besman_echo_yellow "Installing BeSLighthouse dependencies ..."
    npm install 2>&1>>$BESLAB_LOG_FILE
    #export NODE_OPTIONS=--openssl-legacy-provider

    __besman_echo_yellow "Setting BeSLighthouse port ..."
    if [ ! -z $BESLAB_DASHBOARD_PORT ];then
      if [ -f package.json ];then	    
        sed -i "/\"start\": \"react-scripts start\"/c \    \"start\": \"PORT=$BESLAB_DASHBOARD_PORT react-scripts start\"," package.json
      else
	__besman_echo_red "File package.json not found in current directory. Can not change the BeSLighthouse port."
	__besman_echo_red "Change the port manually in package.json and restart BeSLighthouse service."
      fi
    else
      if [ -f package.json ];then
        sed -i "/\"start\": \"react-scripts start\"/c \    \"start\": \"PORT=80 react-scripts start\"," package.json
      else
        __besman_echo_red "File package.json not found in current directory. Can not change the BeSLighthouse port."
        __besman_echo_red "Change the port manually in package.json and restart BeSLighthouse service."
      fi
    fi

    if [ -f ./beslighthouse.sh ];then
       __besman_echo_yellow "Enabling BeSLighthouse service ..." 	    
       cp beslighthouse.service /lib/systemd/system/beslighthouse.service | __beslab_log
       cp beslighthouse.sh /usr/lib/beslighthouse.sh | __beslab_log
       chmod +x /usr/lib/beslighthouse.sh | __beslab_log
       sudo systemctl daemon-reload 2>&1 | __beslab_log
       sudo systemctl enable beslighthouse.service 2>&1 | __beslab_log
       sudo systemctl start beslighthouse.service 2>&1 | __beslab_log
       __besman_echo_yellow "Starting BeSLighthouse service. Please wait ..."

       sleep 150s
       is_active_besl=`systemctl is-active "beslighthouse.service"`

       if [ $is_active_besl == "active" ];then
	  __besman_echo_green " ###############################################################################"     
          __besman_echo_green " ######### BeSLighthouse version $beslight_ver started successfully ############"
	  __besman_echo_green " ###############################################################################"
       else
          __besman_echo_red"   Beslighthouse service failed to start."
	  __besman_echo_red "   Check the service using \"systemctl status beslighthouse.service\""
          __besman_echo_red "   Start BeSLighthouse manually by following the below steps:"
	  __besman_echo_red "       cd /opt/BeSLighthouse"
	  __besman_echo_red "       npm start &"
	  #return 1
       fi
    else
      __besman_echo_yellow "Strating BeSLighthouse without service. Please wait for BeSLighthouse to UP ..."	    
      npm start &
      sleep 150s
      __besman_echo_green " ###############################################################################"
      __besman_echo_green " ######### BeSLighthouse version $beslight_ver started successfully ############"
      __besman_echo_green " ###############################################################################"

    fi
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
