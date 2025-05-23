#!/bin/bash
labToken="LabSeeding$RANDOM"
besuserToken="BeSUserToken$RANDOM"

if [ ! -z $BESLAB_DOMAIN_NAME ];then
   gitlabURL="http://$BESLAB_DOMAIN_NAME"
   if [ ! -z $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT ];then
      gitlabLocalHost="http://localhost:$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT"
   else
      gitlabLocalHost="http://localhost:8081"
   fi
else
   myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
   if [ ! -z $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT ];then
      gitlabURL="http://$myip:$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT"
      gitlabLocalHost="http://localhost:$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT"
   else
      gitlabURL="http://$myip:8081"
      gitlabLocalHost="http://localhost:8081"
   fi
fi


function add_users_from_file () 
{
   pass='Welc0me@123'
   while IFS=: read -r labname firstname lastname username email isadmin isexternal isprivate
   do

      if [[ ! -z $labname && "$labname" =~ ^gitlab && ! -z $email && ! -z $username && ! -z $firstname ]];then

          sudo gitlab-rails runner "u = User.new(username: '$userName', email: '$email', name: '$firstname $lastname ', password: '$pass', password_confirmation: '$pass', admin: '$isadmin'); u.assign_personal_namespace(Organizations::Organization.default_organization); u.skip_confirmation! ; u.save! " 2>&1
          if [ xx"$?" == xx"0" ];then
             __bliman_echo_green "User $firstname created with $username"
          else
             __bliman_echo_red "Error in creating user $firstname with $username"
          fi

      elif [[ -z $labname || "$labname" =~ ^github ]];then
              __bliman_echo_red "$labname is not a valid code collaboration platform or not supported yet"
              return 1
      else
               __bliman_echo_red "Not all required data is provided for creation of user."
              return 1
      fi
   done < "$BESLAB_GITLAB_USERS_FILE"
}

function add_projects_from_file () 
{

   if [ -f $HOME/.besman/gitlabUserDetails ];then
        retrievedToken=`cat $HOME/.besman/gitlabUserDetails | grep GITLAB_USERTOKEN: | cut -d ':'  -f 2 | awk '{$1=$1};1'`
        userToken="$2$retrievedToken"
   elif [ -f $HOME/.bliman/gitlabUserDetails ];then
        retrievedToken=`cat $HOME/.besman/gitlabUserDetails | grep GITLAB_USERTOKEN: | cut -d ':'  -f 2 | awk '{$1=$1};1'`
        userToken="$2$retrievedToken"
   else
       userToken="$1"
   fi
   
   while IFS=: read -r labname reponame repodesc visibility
   do
     if [[ ! -z $labname && $labname =~ ^gitlab && ! -z $reponame && ! -z $visibility ]];then
        CODE=$(curl -k -sS --output /dev/null --write-out '%{http_code}' --request POST --header "PRIVATE-TOKEN: $userToken" --header 'Content-Type: application/json' --data  "{\"name\": \"$reponame\", \"description\": \"$repodesc\", \"initialize_with_readme\": \"true\", \"visibility\": \"$visibility\" }" --url "$gitlabLocalHost"'/api/v4/projects/' 2>&1)

        if [[ "$CODE" =~ ^2 ]];then
            __bliman_echo_green "Project $reponame is created from file $2."
              else
            __bliman_echo_red "Error in creating project $reponame."
               fi
     elif [[ -z $labname || "$labname" =~ ^github ]];then
              __bliman_echo_red "$labname is not a valid code collaboration platform or not supported yet"
              return 1
     else
               __bliman_echo_red "Not all required data is provided for creation of project."
              return 1
     fi

   done < "$BESLAB_GITLAB_PROJECTS_FILE"
}

function __besman_create_gitlabuser()
{
    userName="$1"
    userEmail="$2"
    userFirstName="$3"
    userLastName="$4"
    userPassword="$5"
    isAdmin="$6"
    __besman_echo_yellow "Creating gitlab user $userName ..."
    sudo gitlab-rails runner "u = User.new(username: '$userName', email: '$userEmail', name: '$userFirstName $userLastName ', password: '$userPassword', password_confirmation: '$userPassword', admin: '$isAdmin'); u.assign_personal_namespace(Organizations::Organization.default_organization); u.skip_confirmation! ; u.save! " 2>&1 | __beslab_log
}

function __besman_create_gitlabuser_token()
{
    userName="$1"
    userToken="$1$2"
    tokenName="token_for_$1_$2"
    __besman_echo_yellow "Creating token for gitlab user $userName ..."
    sudo gitlab-rails runner "token = User.find_by_username('$userName').personal_access_tokens.create(scopes: ['api','admin_mode', 'read_repository', 'write_repository' ], name: '$tokenName', expires_at: 365.days.from_now); token.set_token('$userToken'); token.save! " 2>&1 | __beslab_log
}

function __besman_create_gitlab_file()
{
    repoName="$1"
    userName="$2"
    userToken="$2$3"
    branchname="$4"
    email="$5"
    content="$6"
    filepath=$7

    if [ -f $HOME/.besman/gitlabUserDetails ];then
        retrievedToken=`cat $HOME/.besman/gitlabUserDetails | grep GITLAB_USERTOKEN: | cut -d ':'  -f 2 | awk '{$1=$1};1'`
    elif [ -f $HOME/.bliman/gitlabUserDetails ];then
        retrievedToken=`cat $HOME/.besman/gitlabUserDetails | grep GITLAB_USERTOKEN: | cut -d ':'  -f 2 | awk '{$1=$1};1'`
    fi
    #userToken="$retrievedToken"

    # Make a request to list projects and store the response in a variable
    response=$(curl --silent --header "PRIVATE-TOKEN: $retrievedToken" "$gitlabLocalHost/api/v4/projects?search=$repoName")

    # Parse the response to extract project ID
    project_id=$(echo "$response" | grep -o '"id":\s*[0-9]*' | grep -o '[0-9]*' | head -1)

    __besman_echo_yellow "Found project with project id $projetc_id"

    __besman_echo_yellow "Creating file $filepath under project $repoName ..."
    
    curl --silent --request POST --header "PRIVATE-TOKEN: $retrievedToken" --header 'Content-Type: application/json' --data  "{\"branch\": \"$branchname\",\"author_name\": \"$userName\", \"content\": \"$content\", \"commit_message\": \"created initial file\" }" --url $gitlabLocalHost'/api/v4/projects/'$project_id'/repository/files/'$filepath

}

function __besman_create_gitlab_repo()
{
    repoName="$1"
    userName="$2"
    #userToken="$2$3"
    repoDesc="$4"

    __besman_echo_yellow "Creating gitlab repo $repoName ..."
    if [ -f $HOME/.besman/gitlabUserDetails ];then
        retrievedToken=`cat $HOME/.besman/gitlabUserDetails | grep GITLAB_USERTOKEN: | cut -d ':'  -f 2 | awk '{$1=$1};1'`
    elif [ -f $HOME/.bliman/gitlabUserDetails ];then
        retrievedToken=`cat $HOME/.besman/gitlabUserDetails | grep GITLAB_USERTOKEN: | cut -d ':'  -f 2 | awk '{$1=$1};1'`
    fi

    #userToken="$retrievedToken"

    #curl -k --silent --request POST --header "PRIVATE-TOKEN: $userToken" --header 'Content-Type: application/json' --data  "{\"name\": \"$repoName\", \"description\": \"$repoDesc\",\"namespace\": \"$userName\", \"initialize_with_readme\": \"true\", \"visibility\": \"public\" }" --url $gitlabLocalHost'/api/v4/projects/'
    returncode=$(curl -k -sS --output /dev/null --write-out '%{http_code}' --request POST --header "PRIVATE-TOKEN: $retrievedToken" --header 'Content-Type: application/json' --data  "{\"name\": \"$repoName\", \"description\": \"$repoDesc\", \"initialize_with_readme\": \"true\", \"visibility\": \"private\" }" --url "$gitlabLocalHost"'/api/v4/projects/' 2>&1)

   if [[ "$returncode" =~ ^2 ]];then
      __bliman_echo_green "Project $repoName is created."
    else
      __bliman_echo_red "Error in creating project $repoName."
      __bliman_echo_white "$returncode"
    fi
}

function __besman_import_github_repos()
{
    repoName="$1"
    userName="$2"
    #userToken="$2$3"
    githubToken="$3"

    __besman_echo_yellow "Creating gitlab repo $repoName ..."
    if [ -f $HOME/.besman/gitlabUserDetails ];then
        retrievedToken=`cat $HOME/.besman/gitlabUserDetails | grep GITLAB_USERTOKEN: | cut -d ':'  -f 2 | awk '{$1=$1};1'`
    elif [ -f $HOME/.bliman/gitlabUserDetails ];then
        retrievedToken=`cat $HOME/.besman/gitlabUserDetails | grep GITLAB_USERTOKEN: | cut -d ':'  -f 2 | awk '{$1=$1};1'`
    fi

    if [ -z $retrievedToken ];then
       __besman_echo_red "No user token found"
       return 1
    fi

    #userToken="$retrievedToken"
    declare -i githubProjectId

    githubProjectId=`curl -sS https://api.github.com/repos/Be-Secure/$repoName | jq '.id'`
    returncode=$(curl -k -sS --output /dev/null --write-out '%{http_code}' --request POST --header "PRIVATE-TOKEN: $retrievedToken" --header 'Content-Type: application/json' --data  "{\"personal_access_token\": \"$githubToken\", \"repo_id\":  $githubProjectId , \"target_namespace\": \"$userName\", \"new_name\": \"$repoName\", \"optionalstages\": { \"single_endpoint_notes_import\": \"true\", \"attachments_import\": \"false\", \"collaborators_import\": \"false\" }}" --url "$gitlabLocalHost"'/api/v4/import/github' 2>&1)

   if [[ "$returncode" =~ ^2 ]];then
      __bliman_echo_green "Project $repoName is created."
    else
      __bliman_echo_red "Error in creating project $repoName."
      __bliman_echo_white "$returncode"
    fi
}

function __besman_revoke_gitlabuser_token()
{
   userName=$1
   userTokenName="$1$2"
   __besman_echo_yellow "Revoking gitlab token for user $userName"

   sudo gitlab-rails runner "PersonalAccessToken.find_by_token('$userTokenName').revoke!"
}
function __besman_install_gitlab()
{

    if [ -z $BESMAN_LAB_NAME ];then
           __besman_echo_red "BESMAN_LAB_NAME is not defined in genesis file. Define BESMAN_LAB_NAME in the genesis file and retry. Exiting ..."
           return 1
    fi

    if [ -z $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION ];then

      __besman_echo_red "Gitlab version is not defined. Please define the gitlab version in genesis.yaml file and try again."
      return 1
    fi
    
    __beslab_createlogfile
    if [ -d "$HOME/.besman" ];then
      gitlab_user_data_file_path="$HOME/.besman/gitlabUserDetails"
    elif [ -d "$HOME/.bliman" ];then
      gitlab_user_data_file_path="$HOME/.bliman/gitlabUserDetails"
    fi

    sudo apt update  2>&1 | __beslab_log
    sudo apt upgrade -y 2>&1 | __beslab_log
    
    __besman_echo_yellow "Installing gitlab dependencies. Please wait ..."
    sudo apt install -y ca-certificates curl openssh-server tzdata 2>&1 | __beslab_log
    sudo apt update  2>&1 | __beslab_log
    sudo apt install curl debian-archive-keyring lsb-release ca-certificates apt-transport-https software-properties-common -y 2>&1 | __beslab_log
    
    __besman_echo_yellow "Installing Gitlab Community Edition. Please wait ..."
    curl --silent https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash 2>&1>$BESLAB_LOG_FILE
    sudo apt update 2>&1 | __beslab_log

    __besman_echo_yellow "Gitlab vesion defined is $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION ..."
    sudo apt install gitlab-ce=$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION -y 2>&1 | __beslab_log
    if [[ $res == *"Version"*"was not Found"* ]];then
        __besman_echo_red "Gitlab version $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION is not found. Please correct the version in genesis file and retry."
        __besman_echo_red "Exiting ..."
        return 1
    fi
    sudo gitlab-ctl reconfigure 2>&1 | __beslab_log
    gitlab_installed_ver=$(sudo gitlab-rake gitlab:env:info | grep "default Version:" | awk '{print $4}')

    if [ ! -z $gitlab_installed_ver ];then
      __besman_echo_green "#########################################################################################################"
      __besman_echo_green "                               Installed Gitlab-CE version $gitlab_installed_ver                         "
      __besman_echo_green "#########################################################################################################"
    
      __besman_echo_yellow "Configuring Gitlab. It may take several minutes please wait ..."
      [[ ! -f /etc/gitlab/gitlab.rb ]] && __besman_echo_red "Gitlab-CE not installed properly" && return 1

      __besman_echo_white "Updating gitlab domain and port ..."
      if [ ! -z $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT ];then
         sed -i "/^external_url/c external_url '$gitlabURL:$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT'" /etc/gitlab/gitlab.rb 2>&1 | __beslab_log
         echo "external_url $gitlabURL:$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT"
      else
         sed -i "/^external_url/c external_url '$gitlabURL'" /etc/gitlab/gitlab.rb 2>&1 | __beslab_log
	 echo "external_url $gitlabURL"
      fi
 
      sudo gitlab-ctl reconfigure 2>&1| __beslab_log
      __besman_echo_green "Gitlab initial configurations are done."
        
      rootPass=`cat /etc/gitlab/initial_root_password | grep "^Password" | awk $'{print $2}'`
    
      if [ ! -f $gitlab_user_data_file_path ];then
         touch $gitlab_user_data_file_path | __beslab_log
      fi

      if [ ! -z $BESLAB_CODECOLLAB_DATASTORES ];then

        __besman_echo_yellow "Setting up users and projects for gitlab ..."

        
	     __besman_create_gitlabuser $BESMAN_LAB_NAME "$BESMAN_LAB_NAME@$BESLAB_DOMAIN_NAME" $BESMAN_LAB_NAME "Administrator" "Welc0me@123" "true"
        
        sleep 10s
        __besman_create_gitlabuser_token $BESMAN_LAB_NAME $labToken

        echo "GITLAB_USERNAME: $BESMAN_LAB_NAME" > $gitlab_user_data_file_path
        echo "GITLAB_USERTOKEN: $BESMAN_LAB_NAME$labToken" >> $gitlab_user_data_file_path
        echo "GITLAB_ROOT_PASS: $rootPass" >> $gitlab_user_data_file_path

        old_ifs="$IFS"
        IFS=","
        for repoName in $BESLAB_CODECOLLAB_DATASTORES
        do
            __besman_create_gitlab_repo $repoName $BESMAN_LAB_NAME $labToken "created $repoName for $BESMAN_LAB_NAME datastore"
        done

        if [ -z $BESLAB_PRIVATELAB_GITHUB_TOKEN ];then
           __beslab_echo_red " GITHUB Toen is needed for importing Github repos"
        else
           sudo gitlab-rails runner "Feature.enable(:override_github_disabled)"
           old_ifs="$IFS"
           IFS=","
           for importRepoName in $BESLAB_GITHUB_IMPORTS
           do
              __besman_import_github_repos $importRepoName $BESMAN_LAB_NAME $BESLAB_PRIVATELAB_GITHUB_TOKEN 
           done
           sudo gitlab-rails runner "Feature.disable(:override_github_disabled)"
        fi

        envpath="$HOME/.besman/envs"
       
        #masterJson=$(cat $envpath/besman-metadata.json)
        #radiusJson=$(cat $envpath/besman-radius.json)
        #opentofuJson=$(cat $envpath/besman-opentofu.json)
        #vulnerJson=$(cat $envpath/besman-vulner.json)

        sleep 10s
        assessment_store_repo_name="besecure-assets-store"
        assessment_store_branch="main"
        assessment_store_email="$BESMAN_LAB_NAME@$BESMAN_LAB_NAME.com"

        __besman_create_gitlab_file $assessment_store_repo_name $BESMAN_LAB_NAME $labToken $assessment_store_branch $assessment_store_email "" "projects%2Fproject-metadata.json"
        __besman_create_gitlab_file  $assessment_store_repo_name $BESMAN_LAB_NAME $labToken $assessment_store_branch  $assessment_store_email "" "projects%2Fproject-version%2F471-radius-Versiondetails.json"
        __besman_create_gitlab_file  $assessment_store_repo_name $BESMAN_LAB_NAME $labToken $assessment_store_branch  $assessment_store_email "" "vulnerabilities%2Fvulnerability-metadata.json"
        __besman_create_gitlab_file  $assessment_store_repo_name $BESMAN_LAB_NAME $labToken $assessment_store_branch  $assessment_store_email "" "models%2Fmodel-metadata.json"
	     __besman_create_gitlab_file  $assessment_store_repo_name $BESMAN_LAB_NAME $labToken $assessment_store_branch  $assessment_store_email "" "datasets%2Fdataset-metadata.json"

        [[ ! -z $BESLAB_GITLAB_USERS_FILE ]] && add_users_from_file
        [[ ! -z $BESLAB_GITLAB_PROJECTS_FILE ]] && add_projects_from_file

	     __besman_echo_green "Setup users and projects for gitlab."

      else
         __besman_echo_red "Gitlab not installed properly."
	      __besman_echo_red "Execute __besman_install_gitlab"
	      return 1
      fi
       #__besman_revoke_gitlabuser_token "labAdmin" "$labToken"
    else
        __besman_echo_red "BESLAB_CODECOLLAB_DATASTORES not defined in genesis file. Define the BESLAB_CODECOLLAB_DATASTORES in genesis file and retry. Exiting ..."
        return 1
    fi
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
