# **User Guide: Establishing and Operating an AI Security Lab with the Be-Secure BeSLab Blueprint**

## **1\. Introduction to the BeSLab AI Security Lab**

### **1.1 Purpose and Need**

In the contemporary digital landscape, organizations increasingly rely on Open Source Software (OSS) and Artificial Intelligence (AI) / Machine Learning (ML) models to drive innovation and operational efficiency. However, this reliance introduces significant security risks stemming from vulnerabilities within these third-party components and the unique attack surfaces presented by AI models themselves. Managing these risks requires a structured, proactive approach. Establishing a dedicated AI Security Lab provides the CISO's organization with the in-house capability to systematically assess, manage, and mitigate the security risks associated with OSS and AI artifacts used or considered by the enterprise.

### **1.2 The Be-Secure Philosophy and BeSLab Blueprint**

The Be-Secure initiative aims to empower organizations and the broader community to fortify open source artifacts – including software projects, ML models, and training datasets – against potential vulnerabilities.1 The BeSLab blueprint emerges from this philosophy, offering a design for an open-source security lab. It is not a single software product but rather an architectural pattern and a collection of tools and processes designed to create a comprehensive security assessment environment.1 A key goal is to provide application security and security operations teams with complete control and transparency over the assessment process for these critical components.1

### **1.3 Value Proposition for the CISO**

Implementing a BeSLab instance offers tangible benefits for the CISO's organization:

* **Standardized Assurance:** Establishes consistent, repeatable processes for security assessments of OSS projects and AI models.  
* **Centralized Visibility:** Provides a single pane of glass (via BeSLighthouse) for tracking Projects of Interest (OSSPoI), Models of Interest (OSSMoI), and associated Vulnerabilities of Interest (OSSVoI).1  
* **Reduced Risk Exposure:** Proactively identifies and facilitates the mitigation of vulnerabilities in critical dependencies before they can be exploited.  
* **Cost Efficiency:** Potentially reduces the overall cost of risk assessment compared to ad-hoc external engagements or manual reviews, especially as the number of tracked assets grows.1  
* **Internal Attestation:** Enables the generation of internal attestations or designations like Trusted and Verified Open Source Software (TAVOSS) for artifacts that pass the lab's scrutiny, providing a measure of internal assurance.1

### **1.4 Scope of this Guide**

This document provides a comprehensive user guide for setting up, configuring, and operating a *private* AI Security Lab based on the BeSLab blueprint within an enterprise environment. It specifically focuses on the 'Lite Mode' deployment, which integrates essential components onto a single host, and details the integration with GitLab Community Edition (CE) as the code collaboration platform. The guide covers the full lifecycle: architecture, prerequisites, installation, onboarding of users, projects, models, and tools, operational workflows for various security assessments, reporting (OSARs), governance (RACI), and configuration of default components.

## **2\. BeSLab Architecture and Components**

### **2.1 Blueprint Overview**

Understanding the BeSLab architecture requires recognizing it as a *blueprint* – a template defining how various components interact to form a functional security lab.1 It leverages existing open-source tools and defines specific Be-Secure utilities and data structures to create a cohesive system for assessing and managing the security of open source artifacts. The architecture is designed for flexibility, allowing organizations to tailor the lab's capabilities to their specific needs.

### **2.2 Core Components**

A typical private BeSLab instance, as described in this guide, comprises the following core components:

* **Git-based Source Code Management (SCM) Platform (e.g., GitLab CE):** This is the backbone of the BeSLab instance. It hosts critical datastore repositories containing configurations, asset definitions (OSSPoI, OSSMoI), assessment playbooks, environment definitions, and assessment results (OSARs).1 The choice of GitLab CE provides a robust, self-hosted platform with features supporting collaboration, version control, and potentially CI/CD integration for automating assessment workflows.  
  * This Git-centric design inherently supports a **GitOps workflow** for managing the lab itself. All configurations and operational state definitions reside in Git repositories. Changes to the lab's setup, tracked assets, assessment playbooks, or environments are managed through Git commits, providing version history, auditability, and the ability to roll back changes. This approach enhances manageability, reproducibility, and disaster recovery capabilities for the lab infrastructure.  
* **Datastore Repositories:** Specific Git repositories within the SCM platform are designated for storing different types of lab data. Common examples include:  
  * BeSEnvironment: Stores definitions and scripts for creating assessment environments.  
  * BeSPlaybook: Contains the scripts and configurations defining assessment workflows.  
  * BeSAssessment: Archives the generated Open Source Assessment Reports (OSARs) and associated metadata.  
  * Asset Stores (e.g., besecure-assets-store): Repositories holding lists and details of tracked OSSPoI, OSSMoI, etc..2 The specific structure and naming convention are important for tools like BeSLighthouse to locate and interpret the data correctly.2  
* **BeSLighthouse:** A web-based dashboard application that serves as the primary user interface for visualizing the lab's data.1 It reads information directly from the designated Git datastore repositories and presents visualizations of tracked assets (PoI, MoI), associated vulnerabilities (VoI), assessment status, and links to detailed reports.2 Its reliance on the Git backend reinforces the GitOps model, as the dashboard reflects the state defined in the repositories.  
* **BLIman (BeSLab Lifecycle Management):** A command-line interface (CLI) utility specifically designed for deploying, configuring, and managing the lifecycle of a BeSLab instance.1 It utilizes a configuration file (genesis.yaml) to define the lab's parameters and provides commands like bli load (to load configuration), bli initmode (to set the deployment mode, e.g., 'lite'), and bli launchlab (to orchestrate the installation of components like GitLab CE and BeSLighthouse).1  
  * Proficiency with CLI tools is essential for administrators managing the BeSLab instance. The reliance on BLIman for core management tasks means that automation efforts, operational runbooks, and troubleshooting will heavily involve executing and scripting these commands.  
* **BeSman (BeS Environment Manager):** Another CLI utility that works in conjunction with BLIman, specifically responsible for creating and managing BeSEnvironments.1 It is typically installed and initialized as part of the BLIman setup process and is used by playbooks or scripts to provision the necessary runtime environments for security tools.1  
* **BeSEnvironment:** Represents a customized computing setup, often containerized or defined by setup scripts, containing the specific tools, libraries, and dependencies required to execute a particular set of security assessments.1 These environments ensure that assessments run consistently and with the correct prerequisites. They are defined in the BeSEnvironment repository and managed by BeSman.1  
* **BeSPlaybook:** An automated workflow or script designed to orchestrate specific security assessment tasks.1 A playbook typically defines which BeSEnvironment to use and which BeSPlugins (security tools) to execute in sequence, along with any necessary configuration or data handling steps. Playbooks codify the assessment process for different types of assets or security checks (e.g., SAST for Python, AI model safety scan).  
* **BeSPlugin:** Represents an integration wrapper for a specific security tool (e.g., SAST scanner, DAST scanner, SCA tool, secrets detector, AI model analyzer). Plugins are the "workhorses" of the lab, performing the actual security scans. They are invoked by BeSPlaybooks within the appropriate BeSEnvironment. The lab's assessment capabilities are directly determined by the range and quality of the integrated BeSPlugins. The BeSLab framework is extensible, allowing new tools to be integrated as plugins over time.

### **2.3 Key Concepts**

Understanding the following concepts is crucial for operating the BeSLab effectively:

* **OSSPoI / OSSMoI / OSSVoI:**  
  * **OSSPoI (Open Source Projects of Interest):** Specific open-source software projects that the organization uses or depends on, which are onboarded into the lab for continuous security assessment and monitoring.  
  * **OSSMoI (Open Source Models of Interest):** Specific open-source AI/ML models used or considered by the organization, onboarded for security and safety assessments.  
  * **OSSVoI (Open Source Vulnerabilities of Interest):** Represents the specific vulnerabilities (often identified by CVE numbers or other identifiers) discovered in the tracked OSSPoI and OSSMoI. The lab focuses on tracking and managing these relevant vulnerabilities.1  
* **OSAR (Open Source Assessment Report):** The standardized output report generated after a BeSPlaybook completes an assessment run on an OSSPoI or OSSMoI.1 It details the scope, methodology, findings (including OSSVoI), risk posture, and potentially remediation guidance. OSARs should ideally conform to the BeS Schema for consistency.4  
* **TAVOSS (Trusted and Verified Open Source Software):** A designation indicating that an OSS project or AI model has undergone a defined assessment process within the BeSLab instance and meets certain security criteria established by the organization.1 Achieving TAVOSS status is an *outcome* of the lab's assurance activities, signifying a higher level of confidence in the artifact's security posture based on the internal assessment process.3 The lab might facilitate the distribution or identification of these TAVOSS-designated versions internally.1  
* **OSAP (Open Source Assurance Provider):** Each BeSLab instance, whether private or public, functions as an OSAP.1 In the context of this guide (a private lab), the CISO's organization acts as its own internal OSAP, providing assurance services for the assets it chooses to monitor.  
* **BeS Schema / Exchange Schema:** A standardized data format defined by the Be-Secure initiative to facilitate the exchange of information about assets, vulnerabilities, and assessments between different components of the BeSLab ecosystem and potentially between different BeSLab instances.1 Adherence to this schema promotes interoperability, enables consistent data processing and visualization (e.g., by BeSLighthouse), simplifies the development of tools that consume lab data, and ensures that generated reports (OSARs) have a uniform structure.4 This focus on standardization future-proofs the lab's data, even in a private deployment.

## **3\. Prerequisites for Deployment**

Before initiating the BeSLab installation, ensure the target environment meets the following prerequisites. Careful preparation prevents common setup issues.

### **3.1 Hardware**

A dedicated host machine (Virtual Machine recommended for flexibility) is required to run the core BeSLab components.

* **Minimum:** 4 vCPU, 8 GB RAM, 16 GB Disk Space.1 *Note: This is the absolute minimum and may result in slow performance, especially for GitLab.*  
* **Recommended for Enterprise Use:** 8+ vCPU, 16+ GB RAM, 100+ GB Disk Space (SSD recommended). Sufficient disk space is crucial for storing GitLab data (repositories, container registry, etc.) and potentially large assessment artifacts or logs.

### **3.2 Software**

The host machine must have the following software installed and configured:

* **Operating System:** Ubuntu Linux (LTS version recommended, as per documentation examples 1). Other Linux distributions might work but may require adjustments.  
* **Essential Utilities:** curl, unzip, bash, git, sudo access for the installing user.1  
* **Container Runtime:** Docker Engine or a compatible container runtime is required, as BLIman typically deploys GitLab CE and BeSLighthouse as containers.  
* **NodeJS:** Required for BeSLighthouse. Version 16.0 or higher is specified.2 Install via package manager or NVM (Node Version Manager).  
* **Python & pip:** May be required for specific BeSPlugins, BeSEnvironments, or alternative installation methods.1 Install Python 3 and pip.

### **3.3 Network**

Configure the network environment appropriately:

* **IP Address/DNS:** The BeSLab host requires a static IP address or a resolvable DNS hostname within the enterprise network. This address will be used to access GitLab and BeSLighthouse UIs.  
* **Internet Access:** The host needs outbound internet access to download BeSLab components (BLIman, Docker images for GitLab, BeSLighthouse, plugins), clone open-source repositories, and fetch vulnerability database updates.  
* **Firewall Rules:** Ensure necessary ports are open:  
  * SSH (typically TCP/22) for administrative access.  
  * HTTP (TCP/80) and/or HTTPS (TCP/443) for accessing the GitLab web UI and API.  
  * BeSLighthouse Port (e.g., TCP/3000 default, or TCP/80 if configured 2) for accessing the dashboard UI.  
  * Potentially other ports if specific plugins or services require them.  
* **Internal Connectivity:** Users (Analysts, Developers) need network access to the GitLab and BeSLighthouse UIs. Systems submitting assets might need API access to GitLab.

### **3.4 GitLab CE**

This guide assumes GitLab CE will be installed *by* the BLIman launchlab process. If an existing GitLab instance is intended for use, significant manual configuration beyond the scope of this standard installation guide would be required to integrate BeSLab components and repositories correctly.

### **3.5 User Accounts**

* **Host OS:** An operating system user account with sudo privileges is required to perform the installation steps.1  
* **GitLab:** Initial administrative credentials for GitLab will be set during installation (via genesis.yaml) and must be changed immediately upon first login.1

### **3.6 Prerequisites Summary Table**

The following table summarizes the key prerequisites for deploying a private BeSLab Lite Mode instance.

| Category | Requirement | Details / Recommendations | Reference |
| :---- | :---- | :---- | :---- |
| **Hardware** | CPU | Min: 4 vCPU, Recommended: 8+ vCPU | 1 |
|  | RAM | Min: 8 GB, Recommended: 16+ GB | 1 |
|  | Disk Space | Min: 16 GB, Recommended: 100+ GB (SSD) | 1 |
| **Software** | Operating System | Ubuntu LTS Recommended | 1 |
|  | Utilities | curl, unzip, bash, git, sudo access | 1 |
|  | Container Runtime | Docker Engine or compatible | Implied |
|  | NodeJS | v16.0+ | 2 |
|  | Python | Python 3, pip (Optional, depending on tools/methods) | 1 |
| **Network** | Host Addressing | Static IP or resolvable DNS hostname | Required |
|  | Internet Access | Outbound access for downloads/updates | Required |
|  | Firewall Ports | SSH (22), HTTP/S (80/443 for GitLab), BeSLighthouse Port (e.g., 3000 or 80), potentially others | Required |
|  | Internal Access | User access to GitLab/BeSLighthouse UIs | Required |
| **Accounts** | Host OS User | User with sudo privileges | 1 |
|  | GitLab Admin | Initial credentials set via genesis.yaml, change immediately | 1 |

**Table 1: Prerequisites Summary**

## **4\. BeSLab Installation Guide (Private Lite Mode via BLIman)**

### **4.1 Overview**

This section provides step-by-step instructions for installing a private BeSLab instance in 'Lite Mode' using the BLIman CLI tool.1 Lite Mode typically installs all core components, including GitLab CE and BeSLighthouse, onto the single prepared host machine. The installation is driven by the genesis.yaml configuration file.

### **4.2 Step 1: Prepare the Host**

Ensure the designated host machine meets all prerequisites outlined in Section 3\. Log in to the host machine using a user account with sudo privileges.1

### **4.3 Step 2: Install BLIman**

BLIman is the primary tool for managing the BeSLab lifecycle.1 Install it using the following commands (referencing the official Be-Secure/BLIman repository for the latest instructions, as indicated in 1):

Bash

\# Example installation commands (Verify against official BLIman README)  
\# Download the installer script (URL might change)  
curl \-sSL \<URL\_TO\_BLIman\_Installer\_Script\> \-o install-bliman.sh

\# Run the installer script  
sudo bash install-bliman.sh

\# Clean up installer script  
rm install-bliman.sh

\# Verify installation by checking the help command  
bli help

Successful execution of bli help should display the available BLIman commands.

### **4.4 Step 3: Configure genesis.yaml**

The genesis.yaml file defines all configuration parameters for the BeSLab instance.1 Create this file in your current working directory (e.g., /home/user/beslab\_setup/genesis.yaml).

Below is a sample structure for a private Lite Mode deployment. **Customize the values** (especially URLs, IPs, ports, and initial credentials) according to your environment.

YAML

\# Sample genesis.yaml for Private Lite Mode  
\# \--- Global Configuration \---  
beslab\_mode: "lite" \# Specifies Lite Mode deployment  
deployment\_type: "private" \# Specifies a private instance

\# \--- GitLab Configuration \---  
gitlab:  
  host\_url: "http://\<YOUR\_GITLAB\_IP\_OR\_DNS\>" \# \*\*REQUIRED\*\*: URL users will use  
  initial\_root\_password: "\<YOUR\_SECURE\_INITIAL\_PASSWORD\>" \# \*\*REQUIRED\*\*: Set a strong temporary password  
  \# Optional: Specify ports if not default 80/443/22  
  \# http\_port: 80  
  \# https\_port: 443  
  \# ssh\_port: 22  
  \# Optional: Specify data volume path  
  \# data\_volume: "/srv/gitlab/data"

\# \--- BeSLighthouse Configuration \---  
beslighthouse:  
  host\_ip: "0.0.0.0" \# Listen on all interfaces within the container  
  host\_port: "3000" \# \*\*REQUIRED\*\*: Port BeSLighthouse will listen on (e.g., 3000\)  
  \# Optional: Specify data volume path  
  \# config\_volume: "/srv/beslighthouse/config"

\# \--- Other Optional Configurations (Add as needed based on BLIman documentation) \---  
\# Example: Default user settings, registry settings, etc.

**Critical Security Note:** Set a strong, unique initial\_root\_password for GitLab. This password **must** be changed immediately after the first login to the GitLab UI. Do not use default or easily guessable passwords. Store this genesis.yaml file securely, as it contains sensitive initial configuration details.

### **4.5 Step 4: Load Configuration**

Use BLIman to parse and load the configuration from your genesis.yaml file 1:

Bash

\# Ensure you are in the directory containing genesis.yaml or provide the full path  
bli load genesis.yaml

BLIman will validate the file structure and load the parameters. Address any errors reported.

### **4.6 Step 5: Initialize Mode**

Initialize BLIman for the specified deployment mode ('lite' in this case) 1:

Bash

bli initmode lite

This command prepares BLIman and potentially sets up necessary base configurations for the Lite Mode deployment.

### **4.7 Step 6: Initialize BeSman**

Initialize the BeS Environment Manager (BeSman), which is typically installed by bli initmode 1:

Bash

source $HOME/.besman/bin/besman-init.sh

This command loads BeSman functions into your current shell environment. Verify the initialization:

Bash

bes help

Successful execution should display the available BeSman commands.1

### **4.8 Step 7: Launch the Lab**

Initiate the BeSLab deployment process 1:

Bash

bli launchlab

This command triggers the core installation process. BLIman will:

* Download necessary Docker images (GitLab CE, BeSLighthouse, etc.).  
* Configure and start the containers based on genesis.yaml settings.  
* Set up networking and volumes.  
* Potentially perform initial seeding of required GitLab structures (groups/projects).

This step can take a considerable amount of time depending on network speed and host performance. Monitor the console output closely for any errors or prompts.

### **4.9 Step 8: Initial Verification**

Once bli launchlab completes successfully, perform these verification steps 1:

1. **Access GitLab UI:** Open a web browser and navigate to the gitlab.host\_url specified in genesis.yaml.  
2. **Login to GitLab:** Log in using the username root and the initial\_root\_password set in genesis.yaml.  
3. **Change GitLab Password:** GitLab will immediately prompt you to change the default root password. Set a new, strong, unique password and store it securely. **This is a critical security step.**  
4. **Access BeSLighthouse UI:** Open another browser tab and navigate to http://\<BeSLab\_Host\_IP\_OR\_DNS\>:\<beslighthouse.host\_port\> (e.g., http://192.168.1.100:3000).  
5. **Verify BeSLighthouse Load:** The BeSLighthouse dashboard should load. Initially, lists like "Projects Of Interest" will likely be empty, which is expected.1  
6. **(Optional) Check Container Status:** On the BeSLab host, use docker ps (or the equivalent for your container runtime) to verify that the GitLab and BeSLighthouse containers (and any supporting containers) are running.

Successful completion of these steps indicates that the core BeSLab infrastructure is installed and operational.

## **5\. GitLab CE Integration and Repository Setup**

### **5.1 Post-Installation GitLab Configuration**

After the initial setup and password change, consider these basic GitLab configurations relevant to BeSLab operation:

* **User Registration:** Navigate to Admin Area \-\> Settings \-\> General \-\> Sign-up restrictions. It is highly recommended to *disable* new sign-ups (Sign-up enabled checkbox unchecked) and potentially enable Require admin approval for new sign-ups if self-registration is needed later. This ensures only authorized personnel can access the lab's SCM.  
* **Group/Project Creation:** Navigate to Admin Area \-\> Settings \-\> General \-\> Account and limit settings. Review permissions related to who can create top-level groups and projects. Initially, restricting this to Administrators might be prudent.  
* **Runner Configuration (Optional \- Future Use):** If planning to use GitLab CI/CD pipelines to automate BeSPlaybook execution later, configure GitLab Runners (either shared or specific) that can execute jobs, potentially interacting with Docker or the BeSLab host environment. This is an advanced step not covered in the basic setup.

### **5.2 Initializing Be-Secure Repositories**

The BeSLab relies on a specific structure of Git repositories within GitLab to store its data and configurations.1 While bli launchlab might perform some initial setup, manual creation or verification of the core repositories might be necessary.

1. **Login to GitLab:** Log in as the root user or another administrative user.  
2. **Create a Top-Level Group:** Create a new group to house all BeSLab-related repositories (e.g., besecure-lab). This helps organize the instance.  
3. **Create Core Repositories:** Within the besecure-lab group, create the following projects (Git repositories):  
   * BeSEnvironment: Stores definitions for assessment environments.  
   * BeSPlaybook: Stores assessment playbook scripts.  
   * BeSAssessment: Stores OSAR output files and assessment metadata.  
   * besecure-assets-store (or similar name based on datastore.ts defaults): Stores lists/definitions of OSSPoI, OSSMoI, etc..2  
   * Potentially others as required by specific configurations or future extensions. Initialize these repositories with a README file. The exact structure and initial content might need refinement based on specific playbook and plugin requirements.

### **5.3 Configuring BeSLighthouse Connection**

BeSLighthouse needs to know where to find the data repositories within your private GitLab instance.2

1. **Locate datastore.ts:** Access the BeSLab host machine via SSH. Locate the BeSLighthouse installation directory. The exact path depends on how BLIman deployed it, but it might be within a Docker volume mount or a standard location like /opt/BeSLighthouse or /usr/local/share/beslighthouse. Inside this directory, find the configuration file, typically src/config/datastore.ts or similar.  
2. **Edit datastore.ts:** Open the file with a text editor (e.g., nano, vim). You will find variables defining the URLs for the datastore repositories. Update these URLs to point to the repositories created in your private GitLab instance within the besecure-lab group.2  
   * Example (modify paths and URLs):  
     TypeScript  
     // Before modification (pointing to public GitHub)  
     // export const PoI\_Repo\_URL \= "https://github.com/Be-Secure/besecure-assets-store.git";  
     // export const Assessment\_Repo\_URL \= "https://github.com/Be-Secure/besecure-assessment-datastore.git";

     // After modification (pointing to internal GitLab)  
     export const PoI\_Repo\_URL \= "http://\<YOUR\_GITLAB\_IP\_OR\_DNS\>/besecure-lab/besecure-assets-store.git";  
     export const Assessment\_Repo\_URL \= "http://\<YOUR\_GITLAB\_IP\_OR\_DNS\>/besecure-lab/BeSAssessment.git";  
     // Update other relevant repository URLs (MoI, ML assessments, etc.) similarly

3. **Restart BeSLighthouse:** For the changes to take effect, restart the BeSLighthouse service or container. If running via Docker:  
   Bash  
   \# Find the BeSLighthouse container ID or name  
   sudo docker ps

   \# Restart the container  
   sudo docker restart \<container\_id\_or\_name\>

4. **Verify Connection:** Refresh the BeSLighthouse UI in your browser. While still empty, check browser developer tools (network tab) or container logs (sudo docker logs \<container\_id\_or\_name\>) for any errors related to accessing the configured GitLab repository URLs. Successful connection means BeSLighthouse can now read data once it's populated.

This configuration establishes the crucial link between the visualization front-end (BeSLighthouse) and the Git-based data back-end, reinforcing the GitOps foundation and the importance of the standardized repository structure for the lab's operation.

## **6\. Onboarding Guide**

With the core BeSLab infrastructure in place, the next step is to onboard users, assets (projects and models), and the tools (plugins) required for assessment.

### **6.1 User Onboarding**

Define roles and assign appropriate permissions within GitLab to control access to lab resources.

* **Typical Roles:**  
  * **Lab Administrator:** Responsible for installing, configuring, maintaining, and upgrading the BeSLab instance; managing users; integrating core plugins/environments/playbooks. Needs high-level access.  
  * **Security Analyst:** Responsible for onboarding assets (OSSPoI/OSSMoI), triggering assessments, reviewing OSARs, triaging vulnerabilities (OSSVoI), and potentially customizing playbooks or integrating specific plugins.  
  * **Developer / Asset Owner:** Submits projects/models for assessment, consumes OSARs for their assets, responsible for remediation based on findings. Needs access primarily to their specific project results.  
  * **CISO / Management:** Oversight role, views dashboards (BeSLighthouse) and summary reports to understand organizational risk posture related to OSS/AI. Typically read-only access.  
* **GitLab Permission Mapping (Example):**  
  * Lab Administrator: Owner role on the top-level besecure-lab group.  
  * Security Analyst: Maintainer role on the besecure-lab group (allowing repository management, potentially pipeline triggering).  
  * Developer / Asset Owner: Developer or Reporter role on specific BeSAssessment sub-projects or asset tracking repositories relevant to them. Access might be granted per project/asset.  
  * CISO / Management: Guest or Reporter role on the besecure-lab group for read-only access to repositories and potentially BeSLighthouse data sources.  
* **Onboarding Process:**  
  1. Lab Administrator logs into GitLab.  
  2. Navigates to Admin Area \-\> Overview \-\> Users.  
  3. Creates new user accounts or invites existing users.  
  4. Navigates to the besecure-lab group \-\> Group information \-\> Members.  
  5. Invites users to the group, assigning the appropriate role based on the mapping above. Adjust permissions on specific sub-projects as needed for finer-grained control.

### **6.2 Project Onboarding (OSSPoI)**

Onboarding Open Source Projects of Interest (OSSPoI) involves adding them to the lab's tracking system, typically managed within a Git repository.

* **Definition:** OSSPoI are specific open-source software projects critical to the organization's operations or products, requiring security assessment.  
* **Process:**  
  1. Identify the target OSSPoI (e.g., a library used in a critical application).  
  2. Locate the designated asset tracking repository in GitLab (e.g., besecure-assets-store).  
  3. Clone the repository locally.  
  4. Edit the relevant file (e.g., osspoi\_list.yaml, projects.json \- the exact format depends on BeSLab configuration) to add the new project. Include required metadata:  
     * Project Name (e.g., Apache Log4j Core)  
     * Source Repository URL (e.g., https://github.com/apache/logging-log4j2.git)  
     * Version(s) of interest (e.g., 2.17.1, main branch)  
     * Potentially, a flag indicating if it's designated for TAVOSS assessment.  
  5. Commit the changes with a descriptive message.  
  6. Push the changes back to the GitLab repository.  
  7. (Optional) A GitLab CI pipeline or a webhook could trigger automated validation or initial processing upon commit.  
* **TAVOSS Designation:** Marking an OSSPoI for TAVOSS implies it will undergo rigorous assessment according to defined playbooks, aiming to achieve the 'Trusted and Verified' status within the organization's context.1 This designation might be a flag in the asset list file or managed through group/project structure.  
* **Example OSSPoI Candidates:** Identifying initial candidates helps jumpstart the lab's value. Consider projects based on criticality, usage prevalence, and known risk profiles.

| OSSPoI Candidate | Rationale | Potential Assessment Focus |
| :---- | :---- | :---- |
| Apache Log4j 2 | Critical logging library; past high-severity vulnerabilities | SCA (Dependencies), SAST (Java) |
| Apache Struts2 | Web framework; history of critical RCE vulnerabilities | SCA, SAST (Java), DAST |
| Spring Boot / Framework | Widely used Java application framework | SCA, SAST (Java), Secrets Scan |
| TensorFlow | Foundational ML framework | SCA (Python deps), SAST (Python) |
| PyTorch | Foundational ML framework | SCA (Python deps), SAST (Python) |
| Node.js Express | Common web framework for Node.js applications | SCA (npm), SAST (JavaScript/TS) |
| Internal Library X | Critical shared component developed internally | SAST, SCA, Secrets Scan |

**Table 2: Example OSSPoI Candidates**

### **6.3 Model Onboarding (OSSMoI)**

Similar to projects, Open Source Models of Interest (OSSMoI) are onboarded for tracking and assessment.

* **Definition:** OSSMoI are specific open-source AI/ML models used, fine-tuned, or considered for use within the organization.  
* **Process:** Follows the same Git-based workflow as OSSPoI, updating a designated list (e.g., ossmoi\_list.yaml within besecure-assets-store). Required metadata typically includes:  
  * Model Name (e.g., BERT Large Uncased)  
  * Source URL (e.g., Hugging Face Hub URL, GitHub repo)  
  * Version/Identifier (e.g., commit hash, tag, specific file checkpoint)  
  * Base Model (if fine-tuned)  
  * License Information  
* **Example OSSMoI Candidates:** Focus on models relevant to the organization's AI initiatives.

| OSSMoI Candidate | Rationale | Potential Assessment Focus |
| :---- | :---- | :---- |
| BERT (e.g., base-uncased) | Popular foundational NLP model | Model Scanning (operator safety, serialization), Provenance |
| Stable Diffusion (e.g., v1.5) | Widely used image generation model | Model Scanning, License Compliance, Potential Bias Checks |
| Llama (e.g., Llama-2-7b-hf) | Common open Large Language Model (LLM) | Model Scanning, Safety Alignment Checks, License Compliance |
| GPT-2 | Foundational LLM, often used for experiments | Model Scanning, Provenance |
| Internally Fine-tuned Model Y | Model derived from OSSMoI, used internally | Model Scanning (inheritance), Fine-tuning Data Privacy |

**Table 3: Example OSSMoI Candidates**

### **6.4 Tool Onboarding (BeSPlugins)**

Integrating security tools via BeSPlugins is fundamental to the lab's assessment capabilities.

* **Definition:** A BeSPlugin is the integration layer that allows a BeSPlaybook to invoke a specific security tool and process its results within the BeSLab framework.  
* **Integration Process:**  
  1. **Identify Tool:** Select the security tool to integrate (e.g., Semgrep for SAST).  
  2. **Check Existing Plugins:** Consult the official Be-Secure/BeSLab-Plugins repository (as mentioned in the query) for pre-built plugins.  
  3. **Develop/Configure Plugin:** If no existing plugin is suitable, one needs to be developed or configured. This typically involves:  
     * Creating a script or configuration file defining how to execute the tool (command-line arguments, input/output handling).  
     * Defining how to parse the tool's output into a standardized format (ideally aligning with BeS Schema elements for findings).  
     * Specifying dependencies required by the tool, which should be included in a relevant BeSEnvironment.  
     * Packaging the plugin according to BeSLab conventions (e.g., a directory structure within the BeSPlaybook or a dedicated plugin repository).  
  4. **Define BeSEnvironment:** Ensure a BeSEnvironment exists (or create one) that contains the tool itself and all its runtime dependencies (e.g., specific Python version, libraries, OS packages). This might involve creating a Dockerfile managed within the BeSEnvironment repository.  
  5. **Reference in BeSPlaybook:** Update or create a BeSPlaybook to invoke the new plugin at the appropriate stage of the assessment workflow.  
* **Extensibility:** This plugin architecture is key to the lab's flexibility. As new security tools emerge or organizational needs change, new plugins can be added to enhance assessment coverage without altering the core BeSLab framework. The lab's value grows directly with the number and quality of its integrated plugins.  
* **Example Default BeSPlugins:** Start with a core set of plugins covering common security assessment types.

| BeSPlugin Example | Tool Integrated (Example) | Security Assessment Type | Purpose |
| :---- | :---- | :---- | :---- |
| Semgrep-Plugin | Semgrep | SAST | Static code analysis for various languages using pattern matching. |
| Trivy-Plugin | Trivy | SCA, Container Scanning | Detects vulnerabilities in OS packages and language dependencies. |
| Bandit-Plugin | Bandit | SAST (Python) | Finds common security issues in Python code. |
| Gitleaks-Plugin | Gitleaks | Secret Scanning | Detects hardcoded secrets (API keys, passwords) in Git history. |
| OWASP-ZAP-Plugin | OWASP ZAP | DAST | Dynamic analysis of web application security vulnerabilities. |
| ModelScan-Plugin | ModelScan (or similar) | AI Model Security | Scans ML models for unsafe operators, serialization issues, etc. |

**Table 4: Example Default BeSPlugins**

## **7\. AI Security Lab Operational Workflows**

Once the lab is set up and initial assets/tools are onboarded, day-to-day operations involve standardized workflows for assessment and vulnerability management.

### **7.1 Asset Submission**

The process for submitting new OSS projects or AI models for assessment needs to be defined. Options include:

* **Manual Git Update:** As described in sections 6.2 and 6.3, authorized users (Developers, Analysts) clone the asset repository, update the list, and push the changes. This is the simplest method aligned with the GitOps approach.  
* **GitLab Merge Request (MR):** A more controlled process where developers submit MRs to the asset repository. Security Analysts review and approve the MR to formally onboard the asset.  
* **API Integration (Advanced):** Develop an internal tool or script that interacts with the GitLab API to add assets to the tracking list, potentially triggered from other internal systems (e.g., CI/CD pipeline, internal software catalog).

### **7.2 Assessment Execution**

Assessments are performed by executing BeSPlaybooks against target assets.

* **Triggering Mechanisms:**  
  * **Manual:** Security Analysts trigger playbooks via CLI commands (interacting with BeSman/BLIman or custom scripts) or potentially through a custom UI element (if developed).  
  * **Scheduled:** Configure cron jobs on the BeSLab host or use GitLab's CI/CD schedules to run specific playbooks periodically (e.g., daily SCA scans).  
  * **Event-Driven (Git Hooks/CI):** Configure GitLab CI/CD pipelines or webhooks on the asset repositories (or the main code repositories) to automatically trigger relevant playbooks upon events like new commits, merge requests, or new version tags.  
* **Playbook Invocation:** The trigger mechanism selects and executes the appropriate BeSPlaybook based on the asset type (OSSPoI vs. OSSMoI), language/framework, and the desired assessment type (e.g., sast-python-standard, ai-model-onboarding-safety).  
* **Environment and Plugin Use:** The selected playbook orchestrates the assessment 1:  
  1. It typically invokes BeSman to prepare or launch the required BeSEnvironment (e.g., pulling/starting a specific Docker container).  
  2. Within that environment, it executes one or more BeSPlugins in sequence.  
  3. Each plugin runs its corresponding security tool against the target asset (code checkout, model file).  
  4. Plugins collect and parse the results from the tools.  
* **Modularity in Action:** This workflow highlights the modularity and extensibility of BeSLab. The effectiveness of an assessment hinges on the combination of the chosen Playbook, the completeness of the Environment, and the capabilities of the invoked Plugins. New assessment types can be added by creating new combinations of these components.

### **7.3 OSAR Generation and Storage**

Assessment results are formalized into standardized reports.

* **Aggregation:** The BeSPlaybook (or a dedicated reporting script called by it) aggregates the findings from all executed plugins.  
* **Formatting:** Results are formatted into an OSAR (Open Source Assessment Report), ideally conforming to the BeS Schema structure 4 (see Section 9.1 for details). This ensures consistency.  
* **Storage:** The generated OSAR file (e.g., in JSON, YAML, or Markdown format) is typically committed to the BeSAssessment Git repository.1 The commit message or file naming convention should link the OSAR to the specific asset (OSSPoI/OSSMoI), its version/commit hash, and the assessment run timestamp or ID. This provides an auditable history of assessments.

### **7.4 BeSLighthouse Visualization**

BeSLighthouse serves as the central dashboard for monitoring lab activities and results.1 Users access it via a web browser to:

* View lists of currently tracked OSSPoI and OSSMoI.  
* Check the status of ongoing or completed assessments.  
* Review historical assessment results for specific assets.  
* Visualize aggregated vulnerability data (OSSVoI), potentially filtered by severity, asset, or time.  
* Access direct links to the detailed OSAR files stored in the BeSAssessment repository for deeper investigation.

### **7.5 Vulnerability Tracking (OSSVoI/CVEs)**

A core function of the lab is tracking identified vulnerabilities.

* **Identification:** BeSPlugins performing SCA, SAST, DAST, etc., identify potential vulnerabilities. These findings, including CVE identifiers where available, are captured in the OSAR.  
* **Extraction & Storage:** A process (within the playbook or a post-processing step) extracts key vulnerability information (CVE ID, CWE ID, severity, affected component/version, description, location) from the OSAR. This structured data (OSSVoI) is stored, potentially:  
  * Directly within the OSAR file in a structured format (e.g., a findings array).  
  * In a separate dedicated vulnerability database or file within the BeSAssessment or another repository, linked back to the OSAR and the affected asset.  
* **Visualization:** BeSLighthouse queries this structured OSSVoI data to provide aggregated views, trends, and lists of outstanding vulnerabilities across all tracked assets.2  
* **Triage & Remediation:** Security Analysts use the OSARs and BeSLighthouse data to triage new findings, prioritize remediation efforts based on severity and context, assign findings to relevant development teams, and track the status of remediation actions.

### **7.6 OASP Engagement Options**

While this guide focuses on a private, internal lab (acting as a private OSAP 1), there are potential future options for engaging with the wider ecosystem, subject to organizational policy:

* **Contribute Back:** Share identified vulnerabilities and suggested patches back to the upstream open source projects.  
* **Data Sharing:** Anonymize and share vulnerability trend data (using the BeS Exchange Schema 1) with trusted partners, industry groups (ISACs), or Be-Secure community initiatives to contribute to collective security intelligence.  
* **Consume External Data:** Integrate external vulnerability feeds (e.g., NVD, vendor advisories, other OSAP reports) to correlate with internal findings and enrich the OSSVoI data.

## **8\. Configuring Default Lab Components**

To ensure the BeSLab instance provides immediate value upon setup, it's essential to configure a baseline set of Environments, Playbooks, and Plugins. These defaults provide core assessment capabilities that can be expanded later.

### **8.1 Purpose of Defaults**

Defining default components establishes a foundational set of security checks applicable to common languages, frameworks, and asset types within the organization. This allows the lab to start performing basic assessments quickly after installation and onboarding the first assets.

### **8.2 Default BeSEnvironments**

These environments provide the necessary runtime context for common security tools. They are typically defined as Dockerfiles or setup scripts within the BeSEnvironment repository.

| BeSEnvironment Name | Key Components Included | Purpose |
| :---- | :---- | :---- |
| python-base-env | Python 3.x, pip, common build tools, Git | Running Python-specific SAST (Bandit, Semgrep) & SCA tools. |
| node-base-env | NodeJS (LTS), npm/yarn, Git | Running JavaScript/TypeScript SAST/Linters, SCA (npm audit/yarn audit). |
| generic-scanner-env | Base Linux (e.g., Alpine/Debian), curl, jq, git, Trivy | Running generic scanners like Trivy (FS), Gitleaks, or simple scripts. |
| ai-model-env | Python 3.x, PyTorch/TF libs, ModelScan deps, Git | Dedicated environment for AI model security/safety scanning tools. |
| java-build-env | JDK (e.g., 11/17), Maven/Gradle, Git | Environment for building Java projects and running Java SAST/SCA tools. |

**Table 5: Example Default BeSEnvironments**

### **8.3 Default BeSPlaybooks**

These playbooks combine environments and plugins to perform standard assessment workflows. They reside in the BeSPlaybook repository.

| BeSPlaybook Name | BeSEnvironment Used | BeSPlugins Invoked (Example) | Suggested Frequency | Purpose |
| :---- | :---- | :---- | :---- | :---- |
| sast-python-standard | python-base-env | Semgrep-Plugin, Bandit-Plugin | On Commit / Pull Request | Basic static analysis security checks for Python projects. |
| sca-generic-standard | generic-scanner-env | Trivy-Plugin (FS mode) | Daily / Weekly | Scans project dependencies for known vulnerabilities (CVEs). |
| secrets-scan-standard | generic-scanner-env | Gitleaks-Plugin | On Commit / Pull Request | Detects potential secrets accidentally committed to Git history. |
| ai-model-onboarding-safety | ai-model-env | ModelScan-Plugin | On New Model Onboarding | Performs initial safety/security checks on newly added AI models. |
| dast-web-scan-basic | generic-scanner-env | OWASP-ZAP-Plugin (Baseline) | Weekly / On Demand | Performs a basic dynamic scan against a deployed web application URL. |

**Table 6: Example Default BeSPlaybooks**

### **8.4 Default BeSPlugins**

The recommended initial set of plugins provides coverage across essential security domains. Refer back to **Table 4: Example Default BeSPlugins** (Section 6.4) for the list, including tools like Semgrep, Trivy, Bandit, Gitleaks, OWASP ZAP, and an AI Model Scanner. Integrating these plugins provides the foundational scanning capabilities orchestrated by the default playbooks.

## **9\. Reporting and Governance**

Effective operation of the AI Security Lab requires standardized reporting and clear governance structures.

### **9.1 Sample OSAR Structure**

Consistent reporting is vital for tracking findings, comparing assessments over time, and communicating risk effectively. The Open Source Assessment Report (OSAR) should be structured logically, ideally aligning with the principles of the BeS Schema.4

| OSAR Section | Content Description | Purpose |
| :---- | :---- | :---- |
| **Metadata** | Assessment ID, Timestamp, Asset ID (OSSPoI/OSSMoI Name), Asset Version/Commit, BeSPlaybook Used, BeSEnvironment Used, Triggering Event (if applicable). | Uniquely identifies the assessment and its context. |
| **Executive Summary** | Brief overview of the assessment scope, key findings, overall risk level (e.g., Critical, High, Medium, Low), and critical recommendations. | Provides a high-level snapshot for management and quick triage. |
| **Asset Details** | Full Name, Source URL, Description, Exact Version/Commit Hash Assessed, License Information (if applicable). | Clearly identifies the specific artifact that was assessed. |
| **Assessment Scope & Methodology** | Description of the checks performed, list of tools (BeSPlugins) executed, specific configurations used (e.g., scan depth, rule sets), any limitations or exclusions. | Defines the boundaries and methods of the assessment for accurate interpretation of results. |
| **Findings Summary** | Aggregated counts of findings categorized by severity (e.g., Critical, High, Medium, Low, Informational). May include charts or tables. | Provides a quantitative overview of the identified issues. |
| **Detailed Findings** | A list of individual findings. Each finding includes: Finding ID, Description, Severity, Status (New, Triaged, Mitigated, False Positive), Location (File, Line, Model Layer, Dependency Name), Evidence/Code Snippet, Remediation Guidance, Associated Identifiers (CVE, CWE \- constituting OSSVoI). | Provides actionable details for each identified vulnerability or issue for analysts and developers. |
| **Attestation (Optional)** | A formal statement regarding the level of assurance provided by this assessment, based on the scope and findings. May reference TAVOSS criteria if applicable. | Formally documents the outcome and confidence level derived from the assessment process. |

**Table 7: OSAR Sample Structure**

### **9.2 RACI Matrix**

A RACI (Responsible, Accountable, Consulted, Informed) matrix clarifies roles and responsibilities for key lab activities, ensuring smooth operation and accountability.

| Activity | CISO | Lab Administrator | Security Analyst | Developer Lead / App Owner | Legal / Compliance |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Lab Setup/Config | A | R | C | I | I |
| User Onboarding | A | R | C | I | I |
| OSSPoI Onboarding | A | C | R | C | I |
| OSSMoI Onboarding | A | C | R | C | C |
| BeSPlugin Integration | A | R | C | I | I |
| Assessment Execution/Scheduling | I | C | R | I | I |
| OSAR Review/Triage | C | I | R | C | C |
| Vulnerability Remediation Tracking | A | I | R | C | I |
| Vulnerability Remediation Implementation | I | I | C | R | I |
| Lab Maintenance/Upgrades | A | R | C | I | I |
| Policy Definition (Scope, SLA) | A | C | C | C | R |

**Table 8: RACI Matrix** *(R=Responsible, A=Accountable, C=Consulted, I=Informed)*

### **9.3 Governance Considerations**

Beyond the RACI matrix, establish clear policies and procedures:

* **Asset Onboarding Criteria:** Define rules for which OSSPoI and OSSMoI must be onboarded (e.g., based on usage in critical systems, external facing applications, handling sensitive data).  
* **Assessment Frequency:** Define minimum assessment frequencies based on asset criticality and type (e.g., SAST/Secrets on commit, SCA daily, DAST weekly, Model Scan on update).  
* **Vulnerability Triage Process:** Document the workflow for reviewing new findings, assigning severity based on organizational context, determining validity (true positive/false positive), and assigning ownership.  
* **Remediation SLAs:** Define expected timelines for acknowledging and fixing vulnerabilities based on severity levels.  
* **Tool Validation & Updates:** Regularly review and update integrated BeSPlugins and their underlying tools. Validate tool effectiveness periodically.  
* **Reporting Cadence:** Define how and when assessment results and risk posture summaries are reported to the CISO and other stakeholders.

## **10\. Deployment and Interaction Diagrams (PlantUML)**

The following diagrams illustrate the BeSLab architecture and key operational flows.

### **10.1 Diagram 1: High-Level Enterprise Deployment**

Code snippet

@startuml  
\!theme plain  
skinparam rectangle\<\<boundary\>\> {  
  borderColor Black  
  borderThickness 1  
}  
skinparam node {  
  borderColor Black  
  borderThickness 1  
}  
skinparam actor {  
  borderColor Black  
  borderThickness 1  
}

rectangle "Enterprise Network" \<\<boundary\>\> {  
  actor "Security Analyst" as Analyst  
  actor "Developer" as Dev  
  actor "CISO / Mgmt" as CISO

  node "BeSLab Host (VM/Server)" as BeSLabHost {  
    cloud "Core BeSLab Services" as CoreServices  
    database "GitLab CE Data" as GitLabData  
    database "Config/Logs" as ConfigData  
  }

  node "Internal Code Repositories" as InternalRepos  
  node "Internal AI Model Stores" as InternalModels  
  node "User Workstations" as Workstations

  Analyst \-- BeSLabHost : Access UI/CLI  
  Dev \-- BeSLabHost : Access UI/Submit Assets  
  CISO \-- BeSLabHost : Access Dashboard (BeSLighthouse)  
  Workstations \--\> Analyst  
  Workstations \--\> Dev  
  Workstations \--\> CISO

  BeSLabHost \-- InternalRepos : Clone/Assess Code  
  BeSLabHost \-- InternalModels : Access/Assess Models  
}

cloud "Internet / External Sources" as Internet {  
  node "OSS Repositories (GitHub, etc.)" as OSSRepos  
  node "AI Model Hubs (Hugging Face, etc.)" as ModelHubs  
  node "Vulnerability Feeds (NVD, etc.)" as VulnFeeds  
  node "Plugin/Tool Updates" as Updates  
}

BeSLabHost \-- Internet : Fetch OSS Code, Models, Updates, Feeds

@enduml

### **10.2 Diagram 2: Detailed BeSLab Component Layout (Lite Mode Host)**

Code snippet

@startuml  
\!theme plain  
skinparam node {  
  borderColor Black  
  borderThickness 1  
}  
skinparam storage {  
  borderColor Black  
  borderThickness 1  
}  
skinparam interface {  
  borderColor Black  
  borderThickness 1  
}

node "BeSLab Host (VM/Server)" as Host {  
  interface "Network Interface (IP/DNS)" as HostNIC

  node "Container Runtime (Docker)" as Docker {  
    node "GitLab CE Container" as GitLab {  
      folder "Git Repositories" as GitRepos \<\<storage\>\>  
      interface "Web UI/API (80/443)" as GitLabNIC  
      interface "SSH (22)" as GitLabSSH  
    }  
    node "BeSLighthouse Container" as Lighthouse {  
      interface "Web UI (3000/80)" as LighthouseNIC  
    }  
    node "BeSEnvironment Containers (Transient)" as EnvContainers {  
      label "Runs BeSPlugins (Tools)"  
    }  
  }

  folder "BLIman / BeSman CLI Tools" as CLITools  
  folder "Configuration Files (genesis.yaml)" as ConfigFiles \<\<storage\>\>  
  folder "Persistent Volumes" as Volumes \<\<storage\>\> {  
    storage "GitLab Data Volume" as GitLabVol  
    storage "BeSLighthouse Config Volume" as LighthouseVol  
    storage "Other Data/Logs" as OtherVol  
  }

  HostNIC \-- GitLabNIC  
  HostNIC \-- LighthouseNIC  
  HostNIC \-- GitLabSSH

  Lighthouse..\> GitLab : Reads Repo Data (Git/API)  
  CLITools \--\> Docker : Manage Containers  
  CLITools \--\> ConfigFiles : Read Config  
  GitLab..\> GitLabVol : Store Data  
  Lighthouse..\> LighthouseVol : Store Config  
  Docker..\> EnvContainers : Start/Stop Assessment Envs  
  EnvContainers..\> GitLab : Clone Code/Assets  
}

@enduml

### **10.3 Diagram 3: Project/Model Onboarding Flow (Git-based)**

Code snippet

@startuml  
\!theme plain  
actor "User (Dev/Analyst)" as User  
participant "Local Workstation" as Local  
participant "GitLab Server\\n(Asset Repo)" as GitLabRepo  
participant "BeSLab System\\n(Monitor/Hook)" as BeSLabSys  
participant "BeSLighthouse" as Lighthouse

User \-\> Local : Clone Asset Repo  
User \-\> Local : Edit Asset List (Add OSSPoI/OSSMoI)  
User \-\> Local : Git Commit  
User \-\> Local : Git Push  
Local \-\> GitLabRepo : Push Changes  
activate GitLabRepo

GitLabRepo \-\> BeSLabSys : Notify (Webhook/Poll)  
activate BeSLabSys  
BeSLabSys \-\> GitLabRepo : Fetch Updated List  
BeSLabSys \-\> BeSLabSys : Validate New Asset Info  
alt Validation OK  
  BeSLabSys \-\> BeSLabSys : Mark Asset as 'Onboarded' / 'Pending Scan'  
  BeSLabSys \-\> Lighthouse : Update Asset List Cache/Display  
else Validation Failed  
  BeSLabSys \-\> User : Notify Failure (e.g., email, comment)  
end  
deactivate BeSLabSys  
deactivate GitLabRepo

@enduml

### **10.4 Diagram 4: Assessment Execution Flow**

Code snippet

@startuml  
\!theme plain  
participant "Trigger\\n(Schedule/Hook/Manual)" as Trigger  
participant "BeSLab Orchestrator\\n(e.g., CI Pipeline/Script)" as Orchestrator  
participant "BeSPlaybook" as Playbook  
participant "BeSman" as Besman  
participant "BeSEnvironment\\n(Container)" as Env  
participant "BeSPlugin(s)" as Plugins  
participant "GitLab Server\\n(Asset/Assessment Repos)" as GitLabRepo  
participant "BeSLighthouse" as Lighthouse

Trigger \-\> Orchestrator : Initiate Assessment (Asset X, Playbook Y)  
activate Orchestrator  
Orchestrator \-\> Playbook : Execute Playbook Y for Asset X  
activate Playbook  
Playbook \-\> Besman : Request Environment Z  
activate Besman  
Besman \-\> Env : Create/Start Environment Z  
activate Env  
Besman \--\> Playbook : Environment Ready  
deactivate Besman  
Playbook \-\> GitLabRepo : Clone/Fetch Asset X Code/Model  
Playbook \-\> Env : Execute Plugin A  
activate Plugins  
Env \-\> Plugins : Run Tool A  
Plugins \--\> Env : Results A  
deactivate Plugins  
Playbook \-\> Env : Execute Plugin B  
activate Plugins  
Env \-\> Plugins : Run Tool B  
Plugins \--\> Env : Results B  
deactivate Plugins  
Env \--\> Playbook : All Plugin Results  
deactivate Env  
Playbook \-\> Playbook : Aggregate Results & Generate OSAR  
Playbook \-\> GitLabRepo : Commit OSAR to BeSAssessment Repo  
activate GitLabRepo  
GitLabRepo \--\> Playbook : Commit Successful  
deactivate GitLabRepo  
Playbook \--\> Orchestrator : Assessment Complete  
deactivate Playbook  
Orchestrator \-\> Lighthouse : Notify/Update Assessment Status  
deactivate Orchestrator

@enduml

### **10.5 Diagram 5: Vulnerability Tracking Flow (OSSVoI)**

Code snippet

@startuml  
\!theme plain  
start  
:Assessment Runs (SAST/SCA/DAST Plugin);  
:Plugin Detects Vulnerability;  
:OSAR Generated with Finding Details (incl. CVE if available);  
:Store OSAR in BeSAssessment Repo;  
:Extract Structured Vulnerability Data (OSSVoI)\\n(CVE, Severity, Component, etc.);  
if (OSSVoI Data Stored Separately?) then (yes)  
  :Store OSSVoI in Vulnerability Datastore\\n(Linked to Asset & OSAR);  
else (no)  
  :OSSVoI Data Resides within OSAR;  
endif  
:BeSLighthouse Reads OSSVoI Data\\n(from Datastore or OSARs);  
:Display Vulnerability in Dashboard\\n(Aggregated Views, Lists);  
:Security Analyst Reviews New OSSVoI;  
:Triage Vulnerability\\n(Validate, Prioritize, Assign Owner);  
:Track Remediation Status\\n(e.g., Open, In Progress, Fixed, False Positive);  
:Update Status in Datastore/OSAR Metadata;  
:BeSLighthouse Reflects Updated Status;  
stop  
@enduml

## **11\. Conclusion**

### **11.1 Benefits Recap**

Implementing an AI Security Lab using the Be-Secure BeSLab blueprint provides the CISO's organization with a powerful, centralized capability to manage the growing security risks associated with open source software and artificial intelligence models. Key benefits include:

* **Standardized and Proactive Assurance:** Moving from ad-hoc reviews to consistent, automated assessments.1  
* **Enhanced Visibility and Control:** Centralized tracking of critical assets (OSSPoI, OSSMoI) and their associated vulnerabilities (OSSVoI) via BeSLighthouse.1  
* **Reduced Risk Posture:** Early identification and facilitated remediation of vulnerabilities in the software supply chain and AI models.  
* **Internal Trust Validation:** The ability to generate internal TAVOSS designations for assessed components, building confidence in their use.1  
* **Extensibility and Adaptability:** A modular architecture based on Playbooks, Environments, and Plugins allows the lab to evolve and integrate new tools and assessment techniques over time.

### **11.2 Next Steps**

Following the successful installation and initial configuration outlined in this guide, prioritize these immediate actions:

1. **Onboard Initial Assets:** Identify and onboard a pilot set of high-priority OSSPoI and OSSMoI based on organizational risk assessment.  
2. **Configure & Test Default Workflows:** Ensure the default BeSPlugins, BeSEnvironments, and BeSPlaybooks (Tables 4, 5, 6\) are correctly configured and execute successfully against test assets.  
3. **User Training:** Train Security Analysts on operating the lab (triggering scans, reviewing OSARs, using BeSLighthouse) and Developers on submitting assets and interpreting results.  
4. **Establish Governance:** Formalize the processes outlined in Section 9.3 (triage, SLAs, reporting) and communicate the RACI matrix (Table 8).  
5. **Secure the Lab:** Implement robust security hardening for the BeSLab host, GitLab instance, and associated accounts. Regularly apply security patches.

### **11.3 Continuous Improvement**

The AI Security Lab is not a static entity. Its value lies in its continuous operation and evolution:

* **Expand Plugin Coverage:** Regularly evaluate and integrate new BeSPlugins for emerging tools and assessment types (e.g., advanced AI safety checks, infrastructure-as-code scanning, license compliance).  
* **Refine Playbooks:** Optimize existing playbooks and create new ones tailored to specific application stacks, risk profiles, or compliance requirements.  
* **Update Environments:** Keep the underlying tools and dependencies within BeSEnvironments up-to-date.  
* **Integrate with DevSecOps:** Explore deeper integration with existing CI/CD pipelines to automate security feedback loops for developers.  
* **Monitor Effectiveness:** Regularly review the lab's performance, the types of vulnerabilities being found, and the speed of remediation to identify areas for improvement in tooling or processes.

By following this guide and embracing a culture of continuous improvement, the CISO's organization can leverage the BeSLab blueprint to build a robust, effective, and adaptable AI Security Lab, significantly strengthening its posture against modern cyber threats.

#### **Works cited**

1. Empowering Open Source Project Security , This Repository includes BeS Environment Scripts to launch an instance of BeSLab \- GitHub, accessed May 1, 2025, [https://github.com/Be-Secure/BeSLab](https://github.com/Be-Secure/BeSLab)  
2. Be-Secure/BeSLighthouse: Community dashboard for security assessment of open source projects of interest for BeSecure community. Various visualizations on Projects of Interest and Vulnerabilities of interest are available in the dashboard \- GitHub, accessed May 1, 2025, [https://github.com/Be-Secure/BeSLighthouse](https://github.com/Be-Secure/BeSLighthouse)  
3. Wipro's Open Source Security Solution for Enhanced Cybersecurity, accessed May 1, 2025, [https://www.wipro.com/cybersecurity/o31e-wipros-open-source-security-program-a-key-initiative-to-enhancing-cybersecurity-with-open-source/](https://www.wipro.com/cybersecurity/o31e-wipros-open-source-security-program-a-key-initiative-to-enhancing-cybersecurity-with-open-source/)  
4. Be-Secure/bes-schema: This repository defines the data ... \- GitHub, accessed May 1, 2025, [https://github.com/Be-Secure/bes-schema](https://github.com/Be-Secure/bes-schema)
