This repository contains a script that automates the provisioning of two Ubuntu based servers namely master and slave.
It contains a second script that automates the deployment of a lamp stack, clones laravel from GitHub, installs all necessary packages, and configures Apache web server and MySQL.
The script also contains an ansible playbook which executes the second script on the slave server and creates a cron job to check the server's uptime every 12am.

Bash Scripts:
-vagrant.sh - This script spins up the master and slave machines in a ~/Documents/vms-2 folder. It works by the configuring the vagrant file to set up the respective machines.
-lamp.sh - Automates deployment of a LAMP stack and clones laravel from laravel's official repository (also installs git and composer which are used to install laravel's dependencies). This script also configures apache web server and My SQL.

Ansible Playbook: conventionally, the ansible playbook consists of a configuration file, inventory file and yaml file.
-ansible.cfg - This is the ansible configuration file in which I set the inventory, private key and disabled host key checking.
-Files - This folder contains the lamp.sh script to be copied and executed by the playbook. Hence it is very important
-inventory - Contains the ip address of the target machine to make it accessible by the playbook.
-slave.yaml - This contains the commands to be executed by the playbook.
command 1 - Creates a cron job to check server uptime every 12am.
command 2 - Copies the lamp.sh script to the slave vm.
command 3 - Makes the script executable (sets execute permission on the script).
command 4 - Runs the lamp.sh script.

How to run the repo
Requirements:
- .env:
Update DB_DATABASE, DB_USERNAME and DB_PASSWORD
- My SQL: 
Accepts the Username, database and password as arguments. Input them when running the script
e.g bash lamp.sh Ire(Username and database) Irexy1(Password)
- apache configuration file:
Change the server name to your ip address.

Note: Run the lamp.sh script as the root user on the master node