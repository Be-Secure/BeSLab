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
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y curl
    curl -fsSL https://code-server.dev/install.sh | sh
    sudo systemctl enable --now code-server@$USER
  SHELL

#install sonarqube with docker
  config.vm.provision "docker" do |docker|
    docker.pull_images "sonarqube"
    docker.run "sonarqube",
      args: "--name sonarqube -p 9000:9000 -p 9092:9092",
      auto_assign_name: false,
      daemonize: true
  end
  
end