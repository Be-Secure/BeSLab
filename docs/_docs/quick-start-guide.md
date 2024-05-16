---
title: "Quick-Start Guide"
permalink: /docs/quick-start-guide/
excerpt: "How to quickly install and setup for BeSLab."
last_modified_at: 2024-05-05T08:48:05-04:00
redirect_from:
  - /theme-setup/
toc: true
---


**Note:** BeSLab only suported on Ubuntu version 22.04 based system.
{: .notice--warning}

## Pre-requisites for private BeSLab deployment

1. Ubuntu VM - Minimum 4vCPU, 8GB RAM, 16GB Disk Space
2. curl

   ```bash
   sudo apt install curl
   ```

3. unzip

   ``` bash
   sudo apt-get install unzip
   ```

4. bash

   ``` bash
   sudo apt-get install bash
   ```

5. AWS Specific Configurations: AWS VM installed with Ubuntu 22.04 does contains some aws specific packages which are installed with older versions so system pop warning messages for those packages and kernel being old version. These pop ups does hamper the non-interactive installation of BeSLab. So to suppress these warning during installation follow the below steps.

   ```bash
   Open file “/etc/needrestart/needrestart.conf”
   Change following parameters and save the changes.

   Uncomment and set $nrconf{restart} = 'a'
   Uncomment $nrconf{kernelhints} = -1;

   Save and exit the file.
   ```

## Installing the BeSLab

### Method 1. Using Jupyter notebook

1. Login to the dedicated machine for this BeSLab instance and switch to sudo user.

2. Install python and pip on the server.

   ```bash
   sudo apt-get update; apt-get upgrade -y
   sudo apt-get -y install python3-pip
   ```

3. Install Jupyter Notebook.

   ```bash
   sudo python3 -m pip install jupyter
   ```

4. Generate the Jupyter notebook config file.

   ```bash
   jupyter notebook --generate-config
   ```

5. Edit the Jupyter config file.

   ``` bash
   vi $HOME/.jupyter/jupyter_notebook_config.py
   ```

   Change following and save

   ``` bash
   c.ServerApp.ip = '0.0.0.0'
   Uncomment c.ServerApp.open_browser = False
   ```

6. Save and close.

7. Run the Jupyter notebook.

   ```bash
   jupyter notebook --allow-root
   ```

   Note down the token and port number from the screen.

8. Open Jupyter notebook UI on your browser using the IP/Domain and port you captured in the previous step.

9. Provide the token copied from step 7 in the Jupyter UI.
10. Downalod the notebook from this [location](https://github.com/Be-Secure/BeSLab/tree/master/notebooks).
11. Click on upload button on right top corner of Jupyter Notebook UI and point to notebook downloaded in the previous step.
12. Read through the notebook and follow the instructions.

### Method 2. Manual Installation

Execute below steps on the machine where BeSLab needs to be installed.

1. Login to the dedicated machine for this BeSLab instance and switch to sudo user.

2. Install BLIman following instructions [here](https://github.com/Be-Secure/BLIman/blob/main/README.md#installing-bliman)

3. Verify the BLIman is installed.

   ```bash
   bli help
   ```

4. Edit the genesis.yaml installed in the current working directory.

5. Load the genesis file.

   ``` bash
   bli load
   ```

6. Initiliaze BLIman. This installs the BeSman utility under the hood.

   ```bash
   bli initmode <mode name>
   ```

   <mode name> can be any one of (host, bare and lite). Only lite mode is avalilable as of now. Example: bli initmode lite

7. Initiaze BeSman.

   ```bash
   source $HOME/.besman/bin/besman-init.sh
   ```

8. Verify besman installation.

   ```bash
   bes help
   ```

9. Launch the lab.

    ```bash
    bli launchlab
    ```

10. Verify the lab installation
    1. Open GitLab. Go to browser and enter <http://gitlab-server-IP>. (Give the actual IP or domain name). Login with the default credentials (Lab name configured in genesis.yaml / Welc0me@123). Change the default password upon login.
    2. Open BeSLighthouse. Go to browser and enter <http://BeSLighthouse-IP:3000>. (Give the actual IP or domain name). BeSLighthouse UI should open up. Click the "Projects Of Interest" tab and verify that it shows an empty list.
