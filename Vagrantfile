# Vagrantfile
require_relative 'variables.rb'

Vagrant.configure("2") do |config|
  # Use the Virtualization provider VirtualBox / hyperV /VmWare
  config.vm.provider $vm_provider do |vb|
    vb.memory = $vb_memory
    vb.cpus = $vb_cpus
  end
   # Configure the VM base box
  config.vm.define $vm_name do |vm|
    vm.box = $box_name
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end  

  # Update the system and install necessary packages
#   config.vm.provision "shell", inline: <<-SHELL
#     sudo apt-get update
#     sudo apt-get install -y curl

#     # Install VS Code
#     curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
#     sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
#     sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
#     sudo apt-get update
#     sudo apt-get install -y code
#   SHELL
end