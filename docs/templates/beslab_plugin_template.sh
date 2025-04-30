function __besman_install_toolname () {
   # - Add Steps to install all the dependencies of the tools.
   # - Add any configurations required for this tool in the genesis file.
   # - The Genesis file can be more than one where the tool may qualify to install
   # - Always add TOOLNAME_INSTALL="" (possible values enabled/disabled) in the genesis file. 

   # - Write steps to install the tool under consideration.

   # - Configure the tool as required.

   # - Test the tool installation

   # - Display the details like URL etc and how to acess the tool.

   echo ""
   return 0
}

function __besman_uninstall_toolname () {
   # - Comment TOOLNAME_INSTALL in the genesis file or make it disabled
   # - Uninstall the dependencies if needed to uninstall.
   # - Uninstall the tool.
   echo ""
   return 0
}

function __besman_update_toolname () {
   # - Check the new version is available.
   # - Steps to update the tool. including databse backup and restore if any
   # - Check the tool is updated succefully
   # - Verify tool is acessible after update.
   # - Display the updated URL etc if required.
   
   echo ""
   return 0
}