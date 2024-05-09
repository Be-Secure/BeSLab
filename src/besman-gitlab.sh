#!/bin/bash
labToken="LabSeeding$RANDOM"
besuserToken="BeSUserToken$RANDOM"
function __besman_create_gitlabuser()
{
    userName="$1"
    userEmail="$2"
    userFirstName="$3"
    userLastName="$4"
    userPassword="$5"
    isAdmin="$6"
    __besman_echo_yellow "Creating gitlab user $userName ..."
    sudo gitlab-rails runner "u = User.new(username: '$userName', email: '$userEmail', name: '$userFirstName $userLastName ', password: '$userPassword', password_confirmation: '$userPassword', admin: '$isAdmin'); u.assign_personal_namespace; u.skip_confirmation! ; u.save! " 2>&1 | __beslab_log
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

    # Make a request to list projects and store the response in a variable
    response=$(curl --silent --header "PRIVATE-TOKEN: $userToken" "http://localhost/api/v4/projects?search=$repoName")

    # Parse the response to extract project ID
    project_id=$(echo "$response" | grep -o '"id":\s*[0-9]*' | grep -o '[0-9]*' | head -1)

    __besman_echo_yellow "Creating file $filepath under project $project_id ..."
    
    curl --silent --request POST --header "PRIVATE-TOKEN: $userToken" --header 'Content-Type: application/json' --data  "{\"branch\": \"$branchname\",\"author_name\": \"$userName\", \"content\": \"$content\", \"commit_message\": \"created initial file\" }" --url 'http://localhost/api/v4/projects/'$project_id'/repository/files/'$filepath 2>&1 | __beslab_log

}

function __besman_create_gitlab_repo()
{
    repoName="$1"
    userName="$2"
    userToken="$2$3"
    repoDesc="$4"

    __besman_echo_yellow "Creating gitlab repo $repoName ..."

    curl -k --silent --request POST --header "PRIVATE-TOKEN: $userToken" --header 'Content-Type: application/json' --data  "{\"name\": \"$repoName\", \"description\": \"$repoDesc\",\"namespace\": \"$userName\", \"initialize_with_readme\": \"true\", \"visibility\": \"public\" }" --url 'http://localhost/api/v4/projects/' 2>&1 | __beslab_log
}
function __besman_revoke_gitlabuser_token()
{
   userName=$1
   userTokenName="$1$2"
   __besman_echo_yellow "Revoking gitlab token for user $userName"

   sudo gitlab-rails runner "PersonalAccessToken.find_by_token('$userTokenName').revoke!" 2>&1 | __beslab_log
}
function __besman_install_gitlab()
{
    local gitlab_version database_path
    gitlab_version=$1
    database_path=$2

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

    if [ ! -z $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION ];then
       __besman_echo_yellow "Gitlab vesion defined is $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION ..."
       #res=$(sudo apt install gitlab-ce=$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION -y)
       sudo apt install gitlab-ce=$BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION -y 2>&1 | __beslab_log
       if [[ $res == *"Version"*"was not Found"* ]];then
          __besman_echo_red "Gitlab version $BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION is not found. Please correct the version in genesis file and retry."
	  __besman_echo_red "Exiting ..."
	  return 1
       fi
    else
       sudo apt install gitlab-ce -y 2>&1 | __beslab_log
    fi

    __besman_echo_yellow "Configuring Gitlab. It will take several minutes please wait ..."
    [[ ! -f /etc/gitlab/gitlab.rb ]] && __besman_echo_red "Gitlab-CE not installed properly" && return 1
    sed -i "/^external_url/c external_url 'http://gitlab.abc.com'" /etc/gitlab/gitlab.rb 2>&1 | __beslab_log
    sudo gitlab-ctl reconfigure 2>&1| __beslab_log

    rootPass=`cat /etc/gitlab/initial_root_password | grep "^Password" | awk $'{print $2}'
    #__besman_echo_green "Gitlab is installed succussfully ..."`
    #__besman_echo_green "Gitlab root password = $rootPass"

    #__besman_create_gitlabuser "besuser" "besuser@domain.com" "BesUser" "Admin" "Welc0me@123" "false"
    #__besman_create_gitlabuser_token "besuser" "$besuserToken"
    gitlab_installed_ver=$(sudo gitlab-rake gitlab:env:info | grep "default Version:" | awk '{print $4}')

    __besman_echo_green "#########################################################################################################"
    __besman_echo_green "                               Installed Gitlab-CE version $gitlab_installed_ver                         "
    __besman_echo_green "#########################################################################################################"

    if [ ! -f $gitlab_user_data_file_path ];then
       touch $gitlab_user_data_file_path | __beslab_log
    fi

    echo "GITLAB_USERNAME: $BESMAN_LAB_NAME" > $gitlab_user_data_file_path
    echo "GITLAB_USERTOKEN: $BESMAN_LAB_NAME$labToken" >> $gitlab_user_data_file_path

    if [ ! -z $BESLAB_CODECOLLAB_DATASTORES ];then
       if [ -z $BESMAN_LAB_NAME ];then
           __besman_echo_red "BESMAN_LAB_NAME is not defined in genesis file. Define BESMAN_LAB_NAME in the genesis file and retry. Exiting ..."
	   exit 1
       fi

       __besman_create_gitlabuser $BESMAN_LAB_NAME "labAdmin@domain.com" $BESMAN_LAB_NAME "Admin" "Welc0me@123" "true"
       __besman_create_gitlabuser_token $BESMAN_LAB_NAME $labToken
       old_ifs="$IFS"
       IFS=","
       __besman_echo_yellow "Creating datastore repos in gitlab. Please wait ..."
       for repoName in $BESLAB_CODECOLLAB_DATASTORES
       do
           __besman_create_gitlab_repo $repoName $BESMAN_LAB_NAME $labToken "created $repoName for datastore"
       done
       envpath="$HOME/.besman/envs"
       
       #masterJson=$(cat $envpath/besman-metadata.json)
       #radiusJson=$(cat $envpath/besman-radius.json)
       #opentofuJson=$(cat $envpath/besman-opentofu.json)
       #vulnerJson=$(cat $envpath/besman-vulner.json)

       sleep 50s
       assement_store_repo_name="besecure-assets-store"
       assement_store_branch="main"
       assement_store_email="$BESMAN_LAB_NAME@$BESMAN_LAB_NAME.com"

       __besman_create_gitlab_file $assement_store_repo_name $BESMAN_LAB_NAME $labToken $assement_store_branch $assement_store_email "" "projects%2Fproject-metadata.json"
       __besman_create_gitlab_file  $assement_store_repo_name $BESMAN_LAB_NAME $labToken $assement_store_branch  $assement_store_email "" "projects%2Fproject-version%2F471-radius-Versiondetails.json"
       __besman_create_gitlab_file  $assement_store_repo_name $BESMAN_LAB_NAME $labToken $assement_store_branch  $assement_store_email "" "projects%2Fproject-version%2F472-opentofu-Versiondetails.json"
       
        __besman_create_gitlab_file  $assement_store_repo_name $BESMAN_LAB_NAME $labToken $assement_store_branch  $assement_store_email "" "vulnerabilities%2Fvulnerability-metadata.json"
        __besman_create_gitlab_file  $assement_store_repo_name $BESMAN_LAB_NAME $labToken $assement_store_branch  $assement_store_email "" "models%2Fmodel-metadata.json"
	__besman_create_gitlab_file  $assement_store_repo_name $BESMAN_LAB_NAME $labToken $assement_store_branch  $assement_store_email "" "datasets%2Fdataset-metadata.json"

       #__besman_revoke_gitlabuser_token "labAdmin" "$labToken"
    else
        __besman_echo_red "BESLAB_CODECOLLAB_DATASTORES not defined in genesis file. Define the BESLAB_CODECOLLAB_DATASTORES in genesis file and retry. Exiting ..."
        exit 1
    fi
    __besman_echo_green "#########################################################################################################"
    __besman_echo_green "                               Gitlab-CE is configured and ready to use                                   "
    __besman_echo_green "#########################################################################################################"
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
