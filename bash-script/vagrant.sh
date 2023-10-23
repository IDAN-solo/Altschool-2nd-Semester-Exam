#!/bin/bash

#Initialising vagrant machine
if [["pwd" == "Documents/vms-2" ]]; then
vagrant init ubuntu/focal64
else
echo "creating vms-2 folder to initialize vm"
mkdir -p ~/Documents/vms-2
cd ~/Documents/vms-2
vagrant init ubuntu/focal64
fi

#configuring vagrantfile to provision the master and slave vm
#configuring vagrantfile to provision the master vm
cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|

config.vm.define "master" do |master|

master.vm.hostname = "master"
master.vm.box = "ubuntu/focal64"
master.vm.network "private_network", ip: "192.168.0.11"

master.vm.provision "shell", inline: <<-SHELL
apt-get update && apt-get upgrade -y
apt-get install -y avahi-daemon libnss-mdns
apt-get install sshpass -y
echo "Hello from the master vm"
SHELL
end

#configuring vagrantfile to provision the slave vm

config.vm.define "slave_1" do |slave_1|

slave_1.vm.hostname = "slave-1"
slave_1.vm.box = "ubuntu/focal64"
slave_1.vm.network "private_network", ip: "192.168.0.10"

slave_1.vm.provision "shell", inline: <<-SHELL
apt-get update && apt-get upgrade -y
apt-get install -y avahi-daemon libnss-mdns
apt-get install sshpass -y
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
echo "Hello from the slave vm"
SHELL
end

config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = "2"
end
end
EOF

#start the master and slave vms
vagrant up
