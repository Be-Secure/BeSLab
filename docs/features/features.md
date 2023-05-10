## RF0.1 **OAH installation**

   oah_installer installs ove-shell :

    a) On Ubuntu Host machine

          - with git and curl
          - with ansible   

    b) On Windows Host without Ansible
          - with git bash ,curl and vagrant
          - with a launcher App

    c) OAH setup on client machines
          - Using ansible

Target Host Machines are

a) Ubuntu Host machine

b) Windows(7/8/10) Host without Ansible

c) MacOS

Target Client Machines :

a) OAH setup on

- oah-vm.box,
- ubuntu14.04.box
- ubuntu16.04.box
- virtualenv.box

**Other environments**

- oah-pi.box

# Using virtualBox and oah-pi.box

#Using vagrant with ove-vm.box

Prepare oah-vm.box with ansible & base os -> publish box to cdn-> developer downloads vagrant,virtualbox,gitbash-> setup of oah-shell is done on host -> use oah-cli to switch to oah-vm of choice.

Another alternative Install paths can be created using Docker or runc.

## RF0.2 **Environment Provisioning using OAH**

  Provisioning OAH VMs using OAH-INFRA

 - On physical ubuntu machine

 - On Vagrant Machine

 - On Docker Machines

 - Using runc

  Provisioning OAH Clusters using OAH-INFRA

  - On physical ubuntu machine

  - On Vagrant Machine

  - On Docker Machines

  - Using runc

## RF0.3 **Validation of VMs and Clusters**

   - OAH-STATS

   - OAH-TEST-VM

## RF0.4 **Building Blocks for New VMs and Clusters**

   - OAH-Ansible-Roles

   - OAH-Tools

       - Generators

       - Testing tools   

   - OAH-INFRA

        - For Base Box/Image Distribution

        - For Regression Testing of Envs

        - Hosting OAH Dashboard generated from oah-stats   

## RF0.5 **Prepare for community Contributed components**

   - Adding OAH-Ansible-Roles

   - Adding more Environments (a.k.a oah-vms or oah-clusters)
        -VM
        -clusters
