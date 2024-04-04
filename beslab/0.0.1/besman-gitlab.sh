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
    
    sudo gitlab-rails runner "u = User.new(username: '$userName', email: '$userEmail', name: '$userFirstName $userLastName ', password: '$userPassword', password_confirmation: '$userPassword', admin: '$isAdmin'); u.assign_personal_namespace; u.skip_confirmation! ; u.save! "
}

function __besman_create_gitlabuser_token()
{
    userName="$1"
    userToken="$1$2"
    tokenName="token_for_$1_$2"
    sudo gitlab-rails runner "token = User.find_by_username('$userName').personal_access_tokens.create(scopes: ['api','admin_mode', 'read_repository', 'write_repository' ], name: '$tokenName', expires_at: 365.days.from_now); token.set_token('$userToken'); token.save! "
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
    response=$(curl --header "PRIVATE-TOKEN: $userToken" "http://localhost/api/v4/projects?search=besecure-assets-datastore")

    # Parse the response to extract project ID
    project_id=$(echo "$response" | grep -o '"id":\s*[0-9]*' | grep -o '[0-9]*')

    echo "Project ID for '$PROJECT_NAME' is $project_id"

    curl --request POST --header "PRIVATE-TOKEN: $userToken" --header 'Content-Type: application/json' --data  "{\"branch\": \"$branchname\",\"author_name\": \"$userName\", \"content\": \"$content\", \"commit_message\": \"created initial file\" }" --url 'http://localhost/api/v4/projects/'$project_id'/repository/files/'$filepath

}

function __besman_create_gitlab_repo()
{
    repoName="$1"
    userName="$2"
    userToken="$2$3"
    repoDesc="$4"
    curl -k --request POST --header "PRIVATE-TOKEN: $userToken" --header 'Content-Type: application/json' --data  "{\"name\": \"$repoName\", \"description\": \"$repoDesc\",\"namespace\": \"$userName\", \"initialize_with_readme\": \"true\", \"visibility\": \"public\" }" --url 'http://localhost/api/v4/projects/'
}
function __besman_revoke_gitlabuser_token()
{
   userName=$1
   userTokenName="$1$2"
   sudo gitlab-rails runner "PersonalAccessToken.find_by_token('$userTokenName').revoke!"
}
function __besman_install_gitlab()
{
    local gitlab_version database_path
    gitlab_version=$1
    database_path=$2

    if [ -d "$HOME/.besman" ];then
      gitlab_user_data_file_path="$HOME/.besman/gitlabUserDetails"
    elif [ -d "$HOME/.bliman" ];then
      gitlab_user_data_file_path="$HOME/.bliman/gitlabUserDetails"
    fi

    __besman_echo_yellow "Updating system"
    sudo apt update
    sudo apt upgrade -y
    
    __besman_echo_yellow "Install dependencies"
    sudo apt install -y ca-certificates curl openssh-server tzdata
    sudo apt update
    sudo apt install curl debian-archive-keyring lsb-release ca-certificates apt-transport-https software-properties-common -y
    
    __besman_echo_yellow "Install Gitlab-CE"
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
    sudo apt update
    sudo apt install gitlab-ce
    
    __besman_echo_yellow "Update gitlab configuration and start"
    [[ ! -f /etc/gitlab/gitlab.rb ]] && echo __besman_echo_red "Gitlab-CE not installed properly" && return 1
    sed -i "/^external_url/c external_url 'http://gitlab.abc.com'" /etc/gitlab/gitlab.rb
    sudo gitlab-ctl reconfigure

    rootPass=`cat /etc/gitlab/initial_root_password | grep "^Password" | awk $'{print $2}'`
    __besman_echo_green "Gitlab root password = $rootPass"

    __besman_create_gitlabuser "besuser" "besuser@domain.com" "BesUser" "Admin" "Welc0me@123" "false"
    __besman_create_gitlabuser_token "besuser" "$besuserToken"

    if [ ! -f $gitlab_user_data_file_path ];then
       touch $gitlab_user_data_file_path
    fi

    echo "GITLAB_USERNAME: labAdmin" > $gitlab_user_data_file_path
    echo "GITLAB_USERTOKEN: labAdmin$labToken" >> $gitlab_user_data_file_path

    if [ ! -z $BESLAB_CODECOLLAB_DATASTORES ];then
       __besman_echo_yellow "Create datastore projects in gitlab"
       __besman_create_gitlabuser "labAdmin" "labAdmin@domain.com" "LabAdmin" "Admin" "Welc0me@123" "true"
       __besman_create_gitlabuser_token "labAdmin" "$labToken"
       old_ifs="$IFS"
       IFS=","
       for repoName in $BESLAB_CODECOLLAB_DATASTORES
       do
           __besman_create_gitlab_repo "$repoName" "labAdmin" "$labToken" "created $repoName for datastore"
       done
       envpath="$HOME/.besman/envs"
       
       masterJson=$(cat $envpath/besman-metadata.json)
       radiusJson=$(cat $envpath/besman-radius.json)
       opentofuJson=$(cat $envpath/besman-opentofu.json)
       vulnerJson=$(cat $envpath/besman-vulner.json)

       __besman_create_gitlab_file "bescure-assets-store" "labAdmin" "$labToken" "main" "besuser@domain.com" $masterJson "projects%2Fproject-metadata.json"
       __besman_create_gitlab_file "besecure-assets-store" "labAdmin" "$labToken" "main" "besuser@domain.com" $radiusJson "projects%2Fproject-version%2F471-radius-Versiondetails.json"
       __besman_create_gitlab_file "besecure-assets-store" "labAdmin" "$labToken" "main" "besuser@domain.com" $opentofuJson "projects%2Fproject-version%2F472-opentofu-Versiondetails.json"
       
        __besman_create_gitlab_file "besecure-assets-store" "labAdmin" "$labToken" "main" "besuser@domain.com" $vulnerJson "vulnerabilities%2Fvulnerability-metadata.json"
        __besman_create_gitlab_file "besecure-assets-store" "labAdmin" "$labToken" "main" "besuser@domain.com" "" "models%2Fmodel-metadata.json"
	__besman_create_gitlab_file "besecure-assets-store" "labAdmin" "$labToken" "main" "besuser@domain.com" "" "dataset%2Fdataset-metadata.json"

       #__besman_revoke_gitlabuser_token "labAdmin" "$labToken"
    fi
    __besman_echo_green "Gitlab Installed Successfully!"
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
