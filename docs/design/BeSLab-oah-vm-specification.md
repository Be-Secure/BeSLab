**Layout**

Each environment must be a git repository

The Folder structure is a below

```
OAH_ENV_ROOT 

- provisioning 
   |- oah-install.yml
   |- oah-remove.yml
   |- oah-reset.yml
   |- oah-update.yml
   |- oah-validate.yml
   |- oah-requirements.yml 

- testing

- host
   |-vagrant
   |-docker
   |-runc 

- oah-config.yml
- install.sh

```

**Naming Convention** :

The Environment repository will have the following naming convention OAH-XXXX-VM . where XXXX is the VM Type Name that uniquely identified the purpose of the VM


**Must Have files** : 

Environment provisioning folder must have the following playbook

- oah-install.yml, # To install the environment
- oah-reset.yml , # To reset the environment
- oah-remove.yml , # To remove the environment
- oah-update.yml , # To update the environment
- oah-validate.yml , # For validation of Environment
- oah-requirements.yml, Requirements yaml to install required roles 

Environments must have 

**oah-config.yml** in {OAH_ENV_ROOT} folder

Depending on the environment modes supported it can also have 

**VagrantFile**,in {OAH_ENV_ROOT}/host/vagrant folder ,  

**DockerFile**,  in docker folder {OAH_ENV_ROOT}/host/docker 

**Makefile** in the runc folder {OAH_ENV_ROOT}/host/runc

An optional raw install script called **install.sh** in top level  {OAH_ENV_ROOT} folder
 

**Environment Setting**

OAH_ENV_ROOT should be set to the toplevel root folder.
