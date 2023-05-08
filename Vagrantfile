# Vagrantfile
require_relative 'variables.rb'
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = "1"
  end
  config.vm.define "beslab" do |bl|
    bl.vm.box = "ubuntu/focal64"
  end
  config.vm.provision "docker" do |docker|
    docker.pull_images "sonarqube"
    docker.run "sonarqube",
      args: "--name sonarqube -p 9000:9000 -p 9092:9092",
      auto_assign_name: false,
      daemonize: true
  end
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y curl
    curl -fsSL https://code-server.dev/install.sh | sh
    sudo systemctl enable --now code-server@$USER
  SHELL
end