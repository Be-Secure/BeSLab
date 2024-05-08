---
title: "Quick-Start Guide"
permalink: /docs/quick-start-guide/
excerpt: "How to quickly install and setup Minimal Mistakes for use with GitHub Pages."
last_modified_at: 2024-05-05T08:48:05-04:00
redirect_from:
  - /theme-setup/
toc: true
---

## Installing the BeSLab

**Note:** BeSLab only suported on Ubuntu based system.
{: .notice--warning}

To install as a Gem-based theme:

1. Download the setup script:

   ```bash
   Curl -o bliman_setup.sh https://raw.githubusercontent.com/Be-Secure/BLIman/main/bliman_setup.sh
   ```

2. Install BLIman:

   ```bash
   ./bliman_setup.sh install --version <BLIman version>
   ```

3. Initialize BLIman:

   ```bash
   Source $HOME/.bliman/bin/bliman-init.sh
   ```

4. Check the installation:

   ```bash
   Bli help
   ```

5. Edit the genesis.yaml file placed in current working directory:

6. Load the genesis file:

   ```bash
   Bli load
   ```

7. Install BeSMan and BeSLab and set BeSLab mode:

   ```bash
   Bli init mode <lite|bare|host>
   ```

8. Initialize BeSman:

   ```bash
   Source $HOME/.besman/bin/besman-init.sh
   ```

9. Launch the lab:

   ```bash
   Bli launchlab
   ```



