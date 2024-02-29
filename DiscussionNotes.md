Date: 29/Feb 2024
-----------------------
Create the Arhitecture Diagram for BeSLab
BeSLab & OSS assessment setup
 
For Individuals(security analyst )
1. Minimal Barebone without bliman(no attestation capabilities can be used for development of BeSPlaybooks)
2. Mini BeSlab setup with default besecure.io or genesis file & user profile affiliated with a registered BeSLab( with attestation and provenance capabilities to track changes and sync up attestation results)
 
For Organisations (BeSLab Admin)
1. Public/hosted setup with genesis file of a register OASP ( A value proposition for organisation constrainted to use low resources settings for assessments, This deployment could feature saas based OSS security tools) and members(users) datastore. 
2. Private with genesis file of a registered OASP but having a private gitlab instance(A deployment designed to operate at scale and optimise the assessment cycle time for various XoI components) and members datastore.

Instructions
1. Hide all the unnecessary components and interactions.
2. Reuse the existing architecture.
3. Don't change the position of elements across slides.
4. Export/Import Schema does not contain assessment data into it. Its only the skeleton of projects.
5. Assume things and pre-requisites to avoid unnecessary interactions.
6. Make it simple and very high level view only.
7. Add the missing parts in the slide sahred by Vinod to keep it consistent across slides.


Date : 9/May 2023

-----------------------
Include  BeSLab environments repo for the BeS community that can work seamlessly on oah-bes-vm in low cost/low resource settings.



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
    - new ansible roles for packagemanager , for desktop/GUI, Users in the OS image,  )
- l1
    - Basic tool stack for lab 
    - ansible roles and bes env and playbooks for besLab tools as determined by genesis file.
    1. VS Code,eclipse
    2. Sbom
    3. Codeql
    4. Docker
    5. Java
    6. sonar
    7. BESman
    8. Bes Devkit (report generator)
    9. BesLighthouse (capabilty to export vulunrability/ asseesment results to other labs and to BES comunity light house)(VeX)
    10. Bes tools to import and export assesment result and share playbooks/environment

- l2 (User shoud be aware about the CE Environment playbooks and the assement report, results, enpoint of tools and various tools installed)
    - project related tool sets
    - CE repo script

-----------------------------
12th May 2023

-----------------------------

bring out the declaration in the beslab_genesis file. 

os images, package manager  ( declare if it would be self host or using community hosted),  Code collaboration platform tool ( declare if it would be self hosted or using community /public ) , Core BeS ansible role ( users, desktop , ide, common toolchain), other BeS tools ( dev sdk etc) , Bes Repos / BeS data stores (for tracking  assessment & reporting ), and collection of BeS tools as a services should all be there in genesis file

 -----------------------------
 17th may 2023
 
 --------------------
- genesis file specification and depending upon the datatype of the parameter add aditional parameter. Ex: assesment data store if it is git we give the git URL. if it is a file then the file location.
- BeSlab cli can also seed diffrent types of gensis file depending on the resource constrain , this is user can select.
- BeSLabCLI - should provision the BesLab and launch the lab
- BeSlab info command to display the endpoints and services running / BesLab export parameters that will be consumed by BeS environments and Bes Env script.
- Genesis file for the cloud environment will be taken up later. all the service will be in a headless mode.
- Launch the MKDocs for existing project 
- BesLab and BesGPT to be announced
-----------------------
TODO 
***Explore ansible agnostic way to install L1 using docker kubernetes, etc
***tools to export and import bes assesment results from bes playbooks

----
25th May Thursday
----
- BeSLab cli installer script → similar to get.besman.io/get.sdkman.io →Installs BeSLab cli.

- BeSLab cli would install the prerequisites to bring up the BeSLab.

- BeSLab cli would have a command to switch installation modes

  - Two modes for BeSLab cli

      - Host mode – virtualbox, vagrant

      - bare metal (install everything on machine)

- BeSLab cli uses oah to launch the lab in two modes.

- BeSLab cli prescribes the roles to oah to install.

- Ansible-role-oah-bes should talk to genesis.yaml file. Design the role so that it is driven by genesis file.

- Update ansible-role-oah-bes with support for other bes tools required for the lab. Everything under L1.

- If we add/delete/update a new service/tool in the genesis file, BeSLab cli would add it into the BeSLab.

---
June 2 2023
---

    1. BLIMAN exports the env vars from genesis.yaml 
    2. Source command should make the cli export the env vars from genesis file.
    3. default_genesis.yaml
    4. default yaml file can be placed at 3 levels – root | user_home | .bliman
    5. customize yaml file at the user home level would override/shadow the default genesis.
    6. BLIman would generate the config.yaml file for oah-bes-vm from genesis.yaml file export variables.
    7. Use the genesis file to update the config files.
    8. 3 approaches to install the BeSLab using BLIman→ 
        1. host mode using oah-bes-vm/ansible
        2. bare metal mode using ansible and oah-bes-vm
        3. directly using besman without oah-bes-vm/ansible using BeSlab env scripts from BeSLab repository.
            1. Minimum tools for rt and bt activities will be installed.
    9. Think about a case where you don’t use ansible → we directly install besman and all the tools are installed using env scripts.
    10. Prefix variable name inside genesis file BESLAB_<var_name> - These vars would be exported by BLIman. Eg:- BESLAB_OS_IMAGE. Note:- The prefix doesn’t go into the genesis file. It would be prefixed while exporting.
    11. BLIMAN_varname would be belong the installer script for BLIman. Eg:- BLIMAN_DIR.
    12. The tools required for setting up the infrastructure of the lab would be installed in the machine itself using the env scripts/ansible. For eg:- for ansible, we need python. So python should be installed in the current machine.
    13. Mention the code collaboration platform for the lab - gitlab, github, bitbucket, openforge.
    14. Give the code collaboration platform an option - self-hosted by the lab or public.
    15. In a low resource setting of the BeSlab, the user would be pointed to the public resources - public github/gitlab.
    16. Beyond code collaboration platform we would have option for opting a private/public -  
        - artifact repositories - jfrog artifactory/binary artifacts - If private, We would install jfrog.
        - image repositories - docker, runc/oci
        - package managers for different languages - python(pip), java (maven, gradle)
        - CI/CD tools - jenkins, gitrunner, etc
        - sast, dast tools
    17. After bringing up the lab `bli status` would list all the BESLAB_vars and their values. eg- BESLAB_GITLAB_URL will give you the url for accessing gitlab. This can be used by the BeSman environment scripts as the prefix to construct the url for accessing the code for a specific project.
    18. `bli validate` - validate all the services/components are installed and available inside the lab. Eg:- It will ping the BESLAB_GITLAB_URL to test whether the gitlab is up and running and revert the message accordingly.

---
June 7 2023
----
1. BLIman should visit the github to get the candidates instead of apis from the ref project.
2. `TODO` - Create a sequence diagram on the end-to-end flow (Trigger is BLIman)

-----
June 14 2023
----

1. Installer url should be user friendly.
  -  Try to run it through github pages
  -  Something on the lines of - `curl -L https://get.bliman.io | bash`

---
July 26
----
A)

1. Once the lab is brought up,
  - We will have env variables containing the endpoints/variables of the tools
   - If its service, it should have the url of the service. Eg - In case of an issue tracker we need to specify the url of the repo.
2. In case of drupal,
  - Once we bring up the lab, it should contain all the tools required for doing a scan on the drupal project.
  - The env scripts (RT) check if the necessary tools are already available by looking up the env variables.
  - If the env vars are available, then the tool will already be setup.
3. Env script is installing an environment a particular project. This is a one time activity. But in case of
4. BeSLab env script, would install all the shared pool of tools/platform that can be leveraged by the rt/bt scripts over what would be installed by the rt/bt scripts.
  - Shared pool of tools/platforms - code collaboration platform, artifact repo, image registry, package managers, internal datastores for the lab, housekeeping utilities for lab(bliman) - would extract info about the lab and activities inside it.
  - The env script would interact with genesis file.
  - The shared pool support the 10 different activities in the lab
5. Start with preparing 3 genesis file for 3 lab profiles (modes).
6. Roll out spec for genesis file.
7. The genesis file has to be independent of the modes.

B)

1. Rework on the beslab genesis file variables. Make it abstracted out from the underlying launch mechanishm. Should be used acorss 3 modes.
2. Comeback with whether we need a beslab roles apart from bes role?
3. Have a mapping done b/w the lab, env scripts and the s/w components that should be installed. It should come out in our Be-Secure lingo - collection of envs and playbooks.
4. Specify the repo from where the distribution happens for all the components that are required for the installation.
5. Use a namespace in the genesis file to seperate out the enterprise version and the community version.
6. The lab env scripts should prepare the set up of datastores even for the first two modes.
7. Genesis file is not coupled with ansible.
8. All variables inside the genesis file has to be converted into a export variable.
9. When you load a genesis file, the env variables has to be refreshed.
10. Any variable used by the lab env script has to be documented for the dev of bes lab scripts.
11. Shared utility - shared across multiple environments.

--------
Sep 6 2023
-------
1. We should be able to recycle environments and should be aligned with the oah-bes-vm.
2. Genesis file tells you what type a lab we want - How the lab has to be configured.
3. The code collaboration platform inside the BLIman should be a variable. We can clone BeSLab from gitlab not just github.
4. The lab is set up for 2 entities.
   - An org such as o31e for a list of poi and the shared tool sets for all its security analysts.
   - For a user - pentester or security analyst for a single project.
5. Explore ways of having the genesis file template as part of the initial script that installs BLIman.
6. Installation of BLIman via curl and zip file. You can have clone as an alternative when the curl doesnt work.
7. Try out installation of BLIman from both github and gitlab.

-------------The below should be moved-------------
1. Think of an approach to map playbooks with env scripts.
   - metadata - data which contains the compatible env script names.
   - naming convention for playbooks which indicate whether it belongs to a particular env script.
2. Have a linting for bes env script repo and bes playbooks repo. To scan and tell whether it has a valid naming convention and it has the necessary hooks(for env script recyclable commands)

