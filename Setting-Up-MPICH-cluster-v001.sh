#!/bin/bash
# a@ub0$ chmod a+x name-of-script.sh
# a@ub0$ sudo bash name-of-script.sh
# a@ub0$ cat /etc/network/interfaces
# a@ub0$ cat /etc/hosts
# q@ub0$ cat /etc/fstab
# set the font size to 24
setfont /usr/share/consolefonts/Lat7-Terminus28x14.psf
# install depepdent packages
Computer_Name=$(uname -n)
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get upgrade
if [ "$Computer_Name" = "ub0" ]
then
	echo "Setting up the hostnames on master server"
	echo >> /etc/hosts
	echo "192.168.133.100 ub0" >> /etc/hosts
	echo "192.168.133.101 ub1" >> /etc/hosts
	echo "192.168.133.102 ub2" >> /etc/hosts
	echo "192.168.133.103 ub3" >> /etc/hosts
	echo "Installing nfs-server on master"
	sudo apt-get install nfs-server
	echo "Updating the masters interfaces"
	# The host-only network interface host ub0
	echo  >> /etc/network/interfaces
	echo "auto eth1" >> /etc/network/interfaces
	echo "iface eth1 inet static" >> /etc/network/interfaces
	echo "address 192.168.133.100" >> /etc/network/interfaces
	echo "netmask 255.255.255.0" >> /etc/network/interfaces
	echo "network 192.168.133.0" >> /etc/network/interfaces
	echo "broadcast 192.168.133.255" >> /etc/network/interfaces
	# create a folder called mirror 
	echo "Creating a mirror folder"
	# editing the mirror folder
	echo "Editing the mirror folder"
	mkdir ./mirror
	echo "Modifying exports file"
	echo "/mirror *(rw,sync)" | sudo tee -a /etc/exports
	sudo service nfs-kernel-server restart
	# editing the fstab file
	echo "Editing the fstab file"
	echo "ub0:/mirror    /mirror    nfs" >> /etc/fstab
	echo "Defining a user mpiu for running mpi programs"
	sudo useradd mpiu
	echo "changing ownership of ./mirror from user u0 to mpiu"
	sudo chown mpiu /mirror
	echo "Installing SSH Server"
	sudo apt-get install openssh server
	echo "Setting up passwordless SSH for communication between nodes"
	su - mpiu
	echo "Then we generate an RSA key pair for mpiu:"
	ssh-keygen -t rsa
	echo "Next, we add this key to authorized keys:"
	cd .ssh
	cat id_rsa.pub >> authorized_keys
elif [ "$Computer_Name" = "ub1" ]
then 
	echo "Setting up the hostnames on slave server"
	echo >> /etc/hosts
	echo "192.168.133.100 ub0" >> /etc/hosts
	echo "192.168.133.101 ub1" >> /etc/hosts
	echo "192.168.133.102 ub2" >> /etc/hosts
	echo "192.168.133.103 ub3" >> /etc/hosts
	echo "Installing nfs-client on slave"
	sudo apt-get install nfs-client
	echo "Updating the slaves interfaces"
	# The host-only network interface host ub1
	echo  >> /etc/network/interfaces
	echo "auto eth1" >> /etc/network/interfaces
	echo "iface eth1 inet static" >> /etc/network/interfaces
	echo "address 192.168.133.101" >> /etc/network/interfaces
	echo "netmask 255.255.255.0" >> /etc/network/interfaces
	echo "network 192.168.133.0" >> /etc/network/interfaces
	echo "broadcast 192.168.133.255" >> /etc/network/interfaces
	# create a folder called mirror 
	echo "Creating a mirror folder"
	mkdir ./mirror
	# mounting the commor folder shared amoung all nodes
	echo "# mounting the commor folder shared amoung all nodes"
	sudo mount ub0:/mirror /mirror
	echo "remounting all partitions by issuing this on all the slave nodes:"
	sudo mount -a
	echo "Defining a user mpiu for running mpi programs"
	sudo chown mpiu /mirror
	echo "Installing SSH Server"
	sudo apt-get install openssh server
elif [ "$Computer_Name" = "ub2" ]
then
	echo "Setting up the hostnames on slave server"
	echo >> /etc/hosts
	echo "192.168.133.100 ub0" >> /etc/hosts
	echo "192.168.133.101 ub1" >> /etc/hosts
	echo "192.168.133.102 ub2" >> /etc/hosts
	echo "192.168.133.103 ub3" >> /etc/hosts
	echo "Installing nfs-client on slave"
	sudo apt-get install nfs-client
	echo "Updating the slaves interfaces"
	# The host-only network interface host ub2
	echo  >> /etc/network/interfaces
	echo "auto eth1" >> /etc/network/interfaces
	echo "iface eth1 inet static" >> /etc/network/interfaces
	echo "address 192.168.133.102" >> /etc/network/interfaces
	echo "netmask 255.255.255.0" >> /etc/network/interfaces
	echo "network 192.168.133.0" >> /etc/network/interfaces
	echo "broadcast 192.168.133.255" >> /etc/network/interfaces
	# create a folder called mirror 
	echo "Creating a mirror folder"
	mkdir ./mirror
	# mounting the commor folder shared amoung all nodes
	echo "# mounting the commor folder shared amoung all nodes"
	sudo mount ub0:/mirror /mirror
	echo "remounting all partitions by issuing this on all the slave nodes:"
	sudo mount -a
	echo "Defining a user for running MPI programs"
	sudo chown mpiu /mirror
	echo "Installing SSH Server"
	sudo apt-get install openssh server
elif [ "$Computer_Name" = "ub3" ]
then
	echo "Setting up the hostnames on slave server"
	echo >> /etc/hosts
	echo "192.168.133.100 ub0" >> /etc/hosts
	echo "192.168.133.101 ub1" >> /etc/hosts
	echo "192.168.133.102 ub2" >> /etc/hosts
	echo "192.168.133.103 ub3" >> /etc/hosts
	echo "Installing nfs-client on slave"
	sudo apt-get install nfs-client
	echo "Updating the slaves interfaces"
	# The host-only network interface host ub3
	echo  >> /etc/network/interfaces
	echo "auto eth1" >> /etc/network/interfaces
	echo "iface eth1 inet static" >> /etc/network/interfaces
	echo "address 192.168.133.103" >> /etc/network/interfaces
	echo "netmask 255.255.255.0" >> /etc/network/interfaces
	echo "network 192.168.133.0" >> /etc/network/interfaces
	echo "broadcast 192.168.133.255" >> /etc/network/interfaces
	# create a folder called mirror 
	echo "Creating a mirror folder"
	mkdir ./mirror
		# mounting the commor folder shared amoung all nodes
	echo "# mounting the commor folder shared amoung all nodes"
	sudo mount ub0:/mirror /mirror
	echo "remounting all partitions by issuing this on all the slave nodes:"
	sudo mount -a
	echo "Defining a user for running MPI programs"
	sudo chown mpiu /mirror
	echo "Installing SSH Server"
	sudo apt-get install openssh server
fi
