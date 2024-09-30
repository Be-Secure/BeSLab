#!/bin/bash
labToken="LabSeeding$RANDOM"
besuserToken="BeSUserToken$RANDOM"

function install_github (){
# Install Guthub CLI

(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
}

function github_login (){

    gh auth login
}

function add_projects_from_file () 
{

   while IFS=: read -r labname reponame repodesc visibility
   do
     if [[ ! -z $labname && $labname =~ ^gitlab && ! -z $reponame && ! -z $visibility ]];then
	     gh repo create $username/$reponame -d $repoDesc --public
             CODE=$(curl -k -sS --output /dev/null --write-out '%{http_code}' --request POST --header "PRIVATE-TOKEN: $1" --header 'Content-Type: application/json' --data  "{\"name\": \"$reponame\", \"description\": \"$repodesc\", \"initialize_with_readme\": \"true\", \"visibility\": \"$visibility\" }" --url "$gitlabLocalHost"'/api/v4/projects/' 2>&1)

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
    response=$(curl --silent --header "PRIVATE-TOKEN: $userToken" "$gitlabLocalHost/api/v4/projects?search=$repoName")

    # Parse the response to extract project ID
    project_id=$(echo "$response" | grep -o '"id":\s*[0-9]*' | grep -o '[0-9]*' | head -1)

    __besman_echo_yellow "Creating file $filepath under project $project_id ..."
    
    curl --silent --request POST --header "PRIVATE-TOKEN: $userToken" --header 'Content-Type: application/json' --data  "{\"branch\": \"$branchname\",\"author_name\": \"$userName\", \"content\": \"$content\", \"commit_message\": \"created initial file\" }" --url $gitlabLocalHost'/api/v4/projects/'$project_id'/repository/files/'$filepath 2>&1 | __beslab_log

}

function __besman_create_gitlab_repo()
{
    repoName="$1"
    userName="$2"
    userToken="$2$3"
    repoDesc="$4"

    __besman_echo_yellow "Creating gitlab repo $repoName ..."
    gh repo create $username/$reponame -d $repoDesc --public

}

function __besman_uninstall_gitlab()
{
	echo "TBD"
}
