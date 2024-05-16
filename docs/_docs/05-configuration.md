---
title: "Configuration"
permalink: /docs/configuration/
excerpt: "Settings for configuring and customizing the theme."
last_modified_at: 2021-05-11T10:40:42-04:00
toc: true
---

Settings that affect your entire site can be changed in [Jekyll's configuration file](https://jekyllrb.com/docs/configuration/): `_config.yml`, found in the root of your project. If you don't have this file you'll need to copy or create one using the theme's [default `_config.yml`](https://github.com/mmistakes/minimal-mistakes/blob/master/_config.yml) as a base.

**Note:** for technical reasons, `_config.yml` is NOT reloaded automatically when used with `jekyll serve`. If you make any changes to this file, please restart the server process for them to be applied.
{: .notice--warning}

Take a moment to look over the configuration file included with the theme. Comments have been added to provide examples and default values for most settings. Detailed explanations of each can be found below.

## Site settings

### Theme

If you're using the Ruby gem version of the theme you'll need this line to activate it:

```yaml
## Defines the lab type used by BeSman.
## Possible inputs: Organization, Individual
## Organization - lab type is organization if security analyst is affiliated to a organization.
## Individual - If the security analyst is independant analyst.
BESMAN_LAB_TYPE: Organization
## Name of the Lab
BESMAN_LAB_NAME: DemoLab
## Version of BeSMan in Github to be installed.
BESMAN_VER: 0.3.3
## Type of lab to be installed.
## Possible inputs: personal, public, private.
## personal: Installs beslab in security analyst personal system only.
## public: Does use public code collab platform e.g github, gitlab etc.
## private: Installs beslab including provate code collab on the organization infra.
BESLAB_LAB_TYPE: private
## Defines the type of BESLAB deployment
## Possible inputs: host, bare, lite
## host: Deploy beslab on a hosted VM based system.
## bare: Deploy beslab on local system or remote system using ansible playbooks.
## lite: Deploy beslab on low capcity system using only shell scripts only.
BESLAB_LAB_MODE: lite
## Version of beslab to be installed.
## Possible inputs: latest, dev, <version number in x.x.x format>.
## latest: will install the latest released version of BeSLab (default).
## dev: To install the development version of BeSLab.
## x.x.x: valid version number to be installed in the format x.x.x e.g 0.1.0.
## [ Note: default is dev released version ]
BESLAB_VERSION: dev
## URL & PATH configurations to checkout BLIman
BLIMAN_BROWSER_URL: https://github.com
BLIMAN_HOSTED_URL: https://raw.githubusercontent.com
BLIMAN_NAMESPACE: Be-Secure
BLIMAN_REPO_URL: https://raw.githubusercontent.com/Be-Secure/BLIman/main
BLIMAN_VERSION: 0.4.1
BLIMAN_LAB_URL: https://raw.githubusercontent.com/Be-Secure/BeSLab/main
## Defines hostname for VM to be installed in HOST mode.
#BESLAB_VM_NAME: BesLab
## Tells which OS to be installed on VM when HOST mode is used.
#BESLAB_VM_OS: ubuntu
## Enable if need to install the Desktop UI for VM in Host mode.
#BESLAB_VM_GUI: true
## Package for the desktop UI required only if UI needed in Host mode.
#BESLAB_GUI: ubuntu-desktop
## Image to be used for the OS installation on VM in Host mode.
#BESLAB_VAGRANT_BOX: hashicorp/bionic64
## User to be created on the VM after installation in Host mode.
#BESLAB_USER: vagrant
## Home directory for the new user created on VM in Host mode.
#BESLAB_PWD: vagrant
## Hostname to be set for the VM installed in Host mode.
#BESLAB_VAGRANT_HOSTNAME: BeSLab.dev
## Name to be assigned to the VM in virtual box for host mode.
#BESLAB_VAGRANT_MACHINE_NAME: BesLab
## Defines the infra type on which beslab to be deployed.
## Possible inputs: cloud, on-prem
#BESLAB_PRIVATE_LAB_INFRA_TYPE: cloud
## Defines the cloud provider for the LAB deployment if lab ifra type is cloud.
## Possible inputs: AWS, Azure, GCP
#BESLAB_PRIVATE_LAB_INFRA_PROVIDER: AWS
## Access token for infra provider CLI if the infra type is cloud.
#BESLAB_PRIVATE_LAB_INFRA_PROVIDER_ACCESS_TOKEN: ===dsfdgsrghtenygnryjwtgntryj
## Public IPs of the servers to be used for the beslab installation.
#BESLAB_PRIVATE_LAB_SERVERS_IPS:
# - 10.20.0.1
# - 10.50.0.1
## List of Usernames to be used for ssh to the lab servers.
## Note:
## [Should have root previllages.]
## [format is IP:Username e.g 10.20.0.1?root
#BESLAB_PRIVATE_LAB_SERVER_SSH_USERNAME:
# - 10.20.0.1?root
# - 10.50.0.1?root
## List of passwords or token to access lab servers.
## Add list item in format <Server IP>?<Server pass/token>
#BESLAB_PRIVATE_LAB_SERVER_SSH_PASS_LIST:
# - 10.20.0.1?Welcome@123
# - 10.50.0.1?Test@123
## Name of the public code collaboration platfrom. e.g Github, Gitlab etc.
#BESLAB_PUBLIC_CODECOLLAB_PROVIDER_NAME: github
## URL of the public code collab to use git commands.
#BESLAB_PUBLIC_CODECOLLAB_PROVIDER_BROWSER_URL: https://github.com
## URL of the public code collab to use git commands.
#BESLAB_PUBLIC_CODECOLLAB_PROVIDER_DOWNLOAD_URL: https://raw.githubusercontent.com
## Username to be used for the access to public code collab platform.
#BESLAB_PUBLIC_CODECOLLAB_USERNAME: abc@xyz.com
## Key token to be used for the access of public code collab platform.
#BESLAB_PUBLIC_CODECOLLAB_ACCESS_TOKEN: gihub_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
## Namespace in the public code collab to fetch lab data from.
#BESLAB_PUBLIC_CODECOLLAB_AFFILIATE_NAMESPACE: Be-Secure
## Namespace to be used for the deployment of the new lab.
#BESLAB_PUBLIC_CODECOLLAB_LAB_NAMESPACE: ABC
## Code collaboration tool to be used for the private lab installation.
BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL: gitlab-ce
## Version of the code collab tool to be installed on the lab.
BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_VERSION: 16.10.3-ce.0
## List of public IPs of the servers to be used for CICD executions.
## [ Note: if commented or no value provided code collab tool's local system will be used for CICD. ]
#BESLAB_PRIVATE_LAB_CODECOLLAB_CICD_SERVERS_LIST:
# - 127.0.0.1
# - 192.168.0.0
# - 172.0.0.0
## Storage path (Mount Point) for the code collaboration tool.
#BESLAB_PRIVATE_LAB_CODECOLLAB_DATABASE_PATH: /opt/database
## Path or directory to which code collab tool is installed.
#BESLAB_PRIVATE_LAB_CODECOLLAB_INSTALL_PATH: /opt/tool/
## URL to be used for the SMTP server for code collab tool.
#BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_SMTP_URL: https://smtp.xx.com
## Username to be used for the SMTP server login by code collab tool.
#BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_SMTP_USER: abc
## Password to be used by the code collab tool for login to the SMTP server.
#BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_SMTP_USER: xxxxxxx
## Port to be used for code collab tool installation.
#BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_PORT: 8080
## Deffault admin password to be set for the code collab tool installed.
#BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_ADMIN_PASS: xxxxxxxx
## Domain name to be used for code collab tool installed.
#BESLAB_PRIVATE_LAB_CODECOLLAB_TOOL_DOMAIN_NAME: o31e.com
## List of datastores to be created in code collaboration tool
BESLAB_CODECOLLAB_DATASTORES:
  - besecure-assessment-datastore
  - besecure-assets-store
  - besecure-ml-assessment-datastore
## List of compilers or development or runtime tools to be installed in beslab.
# values: - Java
# - GDB
# - Makefile
# - C
# - Python
# - Perl
# - SQL
# - MYSQL
# - PGSQL
# - APACHE
# - npm
# - maven
# - pip3
# - vscode
# - gradle
# - docker
# -
# etc
# BESLAB_DEV_TOOLS:
# - JAVA
# - Python
# - APACHE
# - MAKEFILE
# - GDB
# - maven
# - docker
# - pip3
## Configurations used for Java installation.
BESLAB_JAVA_FLAVOUR: openjdk
BESLAB_JAVA_VERSION: 8
BESLAB_JAVA_HOME: /opt/tools/
## Configuration to be used for python.
#BESLAB_PYTHON_VERSION: 3.10
## Configurations to be used for maven installations
#BESLAB_MAVEN_VERSION:
## Configurations to be used for the gradle installation.
#BESLAB_GRADLE_VERSION:
## Configurations for SBOM generator. If commented no SBOM generator will be installed.
#BESLAB_SBOM: spdx-sbom-generator
#BESLAB_SBOM_VERSION: "v0.0.15"
## Configurations for the tool to be used for finding licensing gaps. If commented no Licensing tool will be installed.
#BESLAB_LICENSE_COMPLIANCE: fossology
## Configurations for the tool to be used for the Static code analysis. If commented no SAST tool will be installed.
#BESLAB_SAST: sonarqube
#BESLAB_SAST_VERSION: "sonarqube-9.8.0.63668"
## List of tools to be installed from Be-Secure community.
#BESLAB_BES_TOOL:
# - besman
# - bes-dev-kit
# - BesLighthouse
## Configurations to be used by the dashboard tool BeSLighthouse.
BESLAB_DASHBOARD_TOOL: BeSLighthouse
BESLAB_DASHBOARD_RELEASE_VERSION: 0.17.6
BESLAB_DASHBOARD_INSTALL_PATH: /opt/BeSLighthouse
BESLAB_DASHBOARD_API_INSTALL_PATH: /opt/BeSRestApi
BESLAB_DASHBOARD_RELEASE_URL: https://github.com/Be-Secure/BeSlighthouse/archive/refs/tags/0.16.2.tar.gz
BESLAB_DASHBOARD_DATASTORES_URL: https://github.com/Be-Secure/
BESLAB_DASHBOARD_POI_NAME: osspoi-datastore
BESLAB_DASHBOARD_MOI_NAME: ossmoi-datastore
BESLAB_DASHBOARD_TDOI_NAME: osstdoi-datastore
BESLAB_DASHBOARD_DOI_NAME: ossdoi-datastore
BESLAB_DASHBOARD_ADS_NAME: ossads-datastore
BESLAB_DASHBOARD_OSAR_NAME: ossosar-datastore
BESLAB_DASHBOARD_ATEESTATION_STORE_NAME: ossattestation-datastore
## Default scope for package manager.
#BESLAB_PACKAGE_MANAGER_SCOPE: public
## Default scope of artifacts
#BESLAB_ARTIFACT_REPO_SCOPE: public
## List of tools to be used for artifacts repos for private access. If commented no private repo tool will be installed.
#BESLAB_PRIVATE_ARTIFACT_REPOS:
# - jfrog
## List of tools to be used for artifacts repos for public access. If commented no public repo tool will be installed.
#BESLAN_PUBLIC_ARTIFACT_REPO:
# - maven
## List of tools to be used for containerization. If commented no containerization tool will be installed.
#BESLAB_CONTAINERIZATION_TOOLS:
# - docker
```
