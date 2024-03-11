#!/bin/bash
function __besman_create_gitlab_repos()
{
    repo_name="$1"
    
    # load personal_access_token (from hardcoded data)
    if [ ! -z $GITLAB_PERSONAL_ACCESS_TOKEN ];then
      personal_access_token=$(echo "$GITLAB_PERSONAL_ACCESS_TOKEN" | tr -d '\r')
    else    
      personal_access_token=$(cat /etc/gitlab/initial_root_password | grep "^Password" | awk '{print $2}')
    fi

    # Create the repository in the GitLab server
    { # try
        output=$(curl -f -X POST -H "PRIVATE_TOKEN: $personal_access_token" -H "Content-Type:application/json" http://127.0.0.1/api/v4/projects -d "{ \"path\": \"$repo_name\", \"visibility\": \"public\" }")

        #output=$(curl -H "Content-Type:application/json" http://127.0.0.1/api/v4/projects?private_token="$personal_access_token" -d "{ \"path\": \"$repo_name\", \"visibility\": \"public\" }")
        echo "output=$output"
        true
    } || { # catch
        true
    }

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
    __besman_echo_yellow "Configure Postfix"
    __besman_echo_yellow "Install Gitlab-CE dependencies"
    sudo apt update
    sudo apt install curl debian-archive-keyring lsb-release ca-certificates apt-transport-https software-properties-common -y
    __besman_echo_yellow "Install Gitlab-CE"
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
    sudo apt update
    sudo apt install gitlab-ce
    __besman_echo_yellow "Install Gitlab-CE"

    [[ ! -f /etc/gitlab/gitlab.rb ]] && echo __besman_echo_red "Gitlab-CE not installed properly" && return 1

    sed -i "/^external_url/c external_url 'http://gitlab.abc.com'" /etc/gitlab/gitlab.rb
    sudo gitlab-ctl reconfigure
}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
