#!/bin/bash
labToken="LabSeeding"
function __besman_create_gitlabAdmin_token()
{
    sudo gitlab-rails runner "u = User.new(username: 'gitlabAdmin', email: 'gitlabAdmin@test.com', name: 'Gitlab Admin ', password: 'Welc0me@123', password_confirmation: 'Welc0me@123', admin: true); u.assign_personal_namespace; u.skip_confirmation! ; u.save! ; token = u.personal_access_tokens.create(scopes: ['api','admin_mode'], name: 'install_token', expires_at: 365.days.from_now); token.set_token($labToken); token.save! "
}
function __besman_create_gitlab_repo()
{
    repoName="$1"
    curl -k --request POST --header "PRIVATE-TOKEN: $labToken" --header 'Content-Type: application/json' --data  "{\"name\": \"$repoName\", \"description\": \"example\",\"namespace\": \"O31E\", \"initialize_with_readme\": \"true\", \"visibility\": \"public\" }" --url 'http://localhost/api/v4/projects/'
}
function __besman_revoke_gitlabAdmin_token()
{
   sudo gitlab-rails runner "PersonalAccessToken.find_by_token($labToken).revoke!"
}
function __besman_install_gitlab()
{
    local gitlab_version database_path
    gitlab_version=$1
    database_path=$2

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
    #__besman_echo_green "Gitlab root password = $rootPass"

    if [ ! -z $BESLAB_CODECOLLAB_DATASTORES ];then
       __besman_echo_yellow "Create datastore projects in gitlab"
       __besman_create_gitlabAdmin_token
       old_ifs="$IFS"
       IFS=","
       labToken=LabSeeding
       for repoName in $BESLAB_CODECOLLAB_DATASTORES
       do
           __besman_create_gitlab_repo "$repoName"
       done
       __besman_revoke_gitlabAdmin_token
    fi
    __besman_echo_green "Gitlab Installed Successfully!"
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
