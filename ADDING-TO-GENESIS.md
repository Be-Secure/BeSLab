# Adding new tool in default genesis.
Please follow below guidelines to add configurations for any new tool in default genesis file.
- Study the tools installation, uninstallatio and update steps.
- Identify the configuration which needs user inputs must.
- There must be a default value for any configuration which is being added in genesis file.
- All configurations adding newly must be assigned the default value or no value in default genesis file.
- The genesis file should be able to install the tool seemlessly without needing any user interaction.
- For any tool there must be two configuration added always as mentioned below.
    - TOOLNAME_INSTALL=disable 
       <br> can be enable/disable, if enabled than only the tool should be installed.
       <br> replace TOOLNAME with the name of the actual tool name to be installed.

    - TOOLNAME_VERSION=""
        <br> Version of the tool to be installed. In the installation script if no version is specified always install the latest release.

- Keep the configurations as minimum as possible in genesis file.
- Put comments for each configuration with descrbing the description of configuration, its possible values.