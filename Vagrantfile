# Vagrantfile
require_relative 'variables.rb'
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    # vb.memory = "4096"
    # vb.cpus = "2"
    vb.gui = true
  end
  config.vm.define "beslab" do |bl|
    bl.vm.box = "ubuntu/focal64"
  end
  config.vm.network "private_network", ip: "192.168.50.10"
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y xfce4
  SHELL
  config.vm.provision "docker" do |docker|
    docker.pull_images "sonarqube"
    docker.run "sonarqube",
      args: "--name sonarqube -p 9000:9000 -p 9092:9092",
      auto_assign_name: false,
      daemonize: true
  end
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y sbom
  SHELL
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y curl
    curl -fsSL https://code-server.dev/install.sh | sh
    sudo systemctl enable --now code-server@$USER
  SHELL
end