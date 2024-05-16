---
title: "BeSLab Configuration File"
permalink: /docs/configuration/
excerpt: "Configuring for BeSLab."
last_modified_at: 2024-05-16T10:40:42-04:00
toc: true
---

## Description

This configuration file, named `genesis.yaml`, is utilized by the BLIman (Be-Secure Lab Instantiator Manager) tool to seed a BeSLab instance. BeSLab is a platform designed for setting up security analysis labs efficiently.

## Usage

The `genesis.yaml` file contains various configuration options that define the setup of the BeSLab instance. These options include specifying the lab type, lab name, version of BeSMan (Be-Secure Management), deployment mode, version of BeSLab, URLs and paths for retrieving necessary files, configuration for Java, dashboard tool settings, code collaboration tool, and more.

## File Contents

The file includes key-value pairs with descriptive comments explaining each configuration option, possible inputs, and their significance in setting up the BeSLab instance.

```yaml
# genesis.yaml

## Defines the configuration options for setting up BeSMan and BeSLab.

# Configuration for BeSMan Lab Type
BESMAN_LAB_TYPE: Organization
# Possible inputs: Organization, Individual
# Description: Specifies the type of lab used by BeSMan. Choose 'Organization' if the security analyst is affiliated with an organization, or 'Individual' if the analyst is independent.

# Configuration for BeSMan Lab Name
BESMAN_LAB_NAME: DemoLab
# Description: Specifies the name of the lab.

# Configuration for BeSMan Version
BESMAN_VER: 0.3.3
# Description: Specifies the version of BeSMan to be installed from Github.

# Configuration for BeSLab Lab Type
BESLAB_LAB_TYPE: private
# Possible inputs: personal, public, private
# Description: Specifies the type of lab to be installed. Choose 'personal' for personal system installation, 'public' for installation with public code collaboration platforms, or 'private' for installation with private code collaboration on organization infrastructure.

# Configuration for BeSLab Lab Mode
BESLAB_LAB_MODE: lite
# Possible inputs: host, bare, lite
# Description: Specifies the type of BESLab deployment. Choose 'host' for hosted VM deployment, 'bare' for local or remote system deployment using Ansible playbooks, or 'lite' for deployment on low-capacity systems using shell scripts.

# Configuration for BeSLab Version
BESLAB_VERSION: dev
# Possible inputs: latest, dev, <version number in x.x.x format>
# Description: Specifies the version of BeSLab to be installed. Choose 'latest' for the latest released version, 'dev' for the development version, or specify a version number in x.x.x format.

# Configuration for BLIman URLs and Paths
BLIMAN_BROWSER_URL: https://github.com
BLIMAN_HOSTED_URL: https://raw.githubusercontent.com
BLIMAN_NAMESPACE: Be-Secure
BLIMAN_REPO_URL: https://raw.githubusercontent.com/Be-Secure/BLIman/main
BLIMAN_VERSION: 0.4.1
BLIMAN_LAB_URL: https://raw.githubusercontent.com/Be-Secure/BeSLab/main
# Description: Specifies the URLs and paths for checking out BLIman.

# Configuration for BeSLab Java
BESLAB_JAVA_FLAVOUR: openjdk
BESLAB_JAVA_VERSION: 8
BESLAB_JAVA_HOME: /opt/tools/
# Description: Specifies configurations for Java installation.

# Configuration for BeSLab Dashboard Tool
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
#  - jfrog

## List of tools to be used for artifacts repos for public access. If commented no public repo tool will be installed.
#BESLAN_PUBLIC_ARTIFACT_REPO:
#  - maven

## List of tools to be used for containerization. If commented no containerization tool will be installed.
#BESLAB_CONTAINERIZATION_TOOLS:
#  - docker

```
