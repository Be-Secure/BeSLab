
Date : 9/May 2023

-----------------------
Include  BeSLab environments repo for the BeS community that can work seamlessly on oah-bes-vm in low cost/low resource settings.

(Important to have this in place asap. I had a quick discussion with Samir & Sudhir.  Being able to present a roadmap for our OSS is critical for us to meaningfully engage community contributors & OSS security researchers.)

a) OSS Security team/OSS Security Researcher (Active Contribution to BeS Community)

Usage Scenarios (Reasons to deploy/use/participate in BeS Community):

Discover vulnerabilities (OSSPoI)
Set up your own BeSLab environment
Submit new BeS Environments
Submit new BeS Playbooks
Submit a scan report for vulnerability assessments
 

b) OSS Solution Developer (Passive Contributions to BeS Community)

Usage Scenarios:

Identify TAVOSS components from OSSPoI
Understand the OSS security posture of OSSPoI from OSSVoI (Vulnerabilities of Interest)
 

c) OSS Community Contributor (BeS Contributors)

Usage Scenarios:

Identify OSS projects to contribute to
Access a "Getting Started" guide for BeS

TO Do:
- Deployment Diag. for the lab

- Tools are required for the standalone operation
     - Code Collab (gitlab)
     - Repo for Artefacts / Binaries
     - Package managers (apt like)
      - IDEs for Dev
     - Red Teaming
        - tools for writing Exploits
        - BESMan
     - Blue Teamin
        - Build and Deploy
     - Assesment tools
     - BesMan
- Design Ansible role
- Develop Bes env Script for tools identified
- Develop the Bes Playbook
  - playbooks to publish assesment results to external repos   
- Design a yaml file for pass configuration to spinoff the lab
    - seed the yaml file to drive nature of Lab (user selection)
        - Default is slim with minimal tool
            - tools
        - substrate is vagrant/VB for OAH -BES -VM
- S/W to spinoff the lab
- pre req vagrant ansible virtualbox (inspiration :SDKMan)
------------------------------
11th May 2023

------------------------------
- Configuration file (genesis.yaml)
  - Instructions of gitlab to be installed or gitlab name space to be pointed
  - need a packagemanager or point to a package manager
  - need to specify OS image or use a existing 
- l0
    - vagrant, Virtual box, oah shell, ansible roles required for installing infra component and configuring user profiles,besman (beslab installer script)
    - new ansible roles for packagemanager , for desktop/GUI, Users in the OS image, roles to install BESman and Bes Developer toolkit)
- l1
    - Basic tool stack for lab 
    - ansible roles and bes env and playbooks for besLab tools as determined by genesis file.
    1. VS Code,eclipse
    2. Sbom
    3. Codeql
    4. Docker
    5. Java
    6. sonar

- l2 (User shoud be aware about the CE Environment playbooks and the assement report, results, enpoint of tools and various tools installed)
    - project related tool sets
    - CE repo script
