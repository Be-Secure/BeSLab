---
title: "BeSLab Deployment Guide"
permalink: /docs/layouts/
excerpt: "Descriptions and samples of all layouts included with the theme and how to best use them."
last_modified_at: 2020-08-30T21:27:40-04:00
toc: true
toc_label: "Included Layouts"
toc_icon: "columns"
---

BeSLab is designed to support the deployment of lab as per the resources available. BeSLab can be installed by hosting a new high-power virtual machine inside a host machine, on a cloud network, or on an individual’s personal machine with minimal resources.

## BeSLab Deployment Modes

### BESLAB_MODE Configuration

BeSLab provides the Lab Administrator configure the mode of lab deployment called BESLAB_MODE, which can have one of the following values:

1. HOST
2. BARE
3. LITE

#### HOST Mode

This mode deploys BeSLab using a virtual machine running on the host machine. All tools and the code collaborator platform are installed on the virtual machine.

#### BARE Mode

In bare mode, all tools and utilities are installed directly on the host machine without the need for a hypervisor or a virtual machine. Ansible roles are used to install the various tools. It does require a moderate amount of resources to deploy the BeSLab instance.

#### LITE Mode

Lite mode is a lightweight BeSLab deployment mode. It requires minimal resources and utilizes only shell scripts, which are widely available in all Linux distributions by default. It does not require additional software such as Ansible or the spinning up of virtual machines.

##### Deployment Types

Lite mode can further be deployed in one of the following deployment types:

1. Private
2. Public
3. Personal

- **Private Deployment**: Code collaboration platform is installed on a private and secure instance of BeSLab. Access to tools, assessment data, and reports are controlled by the owner.
  
- **Public Deployment**: BeSLab instance does not include a private code collaboration platform. Tools and utilities are provided for security analysts to access Open-Source Projects, AI Models, Datastore, etc. Access is controlled by the owner, with data stored on a public code collaboration platform.

- **Personal Deployment**: BeSLab is deployed on low-resource machines using only shell scripts. No code collaboration tool is installed, and only minimal tools needed for reports, development, and attestation are included. This mode is suitable for development, hobbyists, students, and academic purposes.

### Features of LITE Mode

- Very low resource deployment, scalable for private labs with full features.
- Deployment via shell scripts.
- Lab components configured via a genesis file.
- Quick installation without the need for separate tools.
