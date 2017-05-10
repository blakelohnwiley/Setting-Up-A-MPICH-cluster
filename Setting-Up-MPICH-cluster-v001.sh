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
echo >> /etc/apt/sources.list
echo "deb http://dk.archive.ubuntu.com/ubuntu/ trusty main universe" >> echo >> /etc/apt/sources.list
echo "deb http://dk.archive.ubuntu.com/ubuntu/ trusty-updates main universe" >> echo >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get install g++-4.4
sudo apt-get install build-essential
if [ "$Computer_Name" = "UbuntuMaster" ]
then
	apt-get install git
	apt-get wget
	git clone git clone https://github.com/blakelohnwiley/Setting-Up-A-MPICH-cluster.git
	echo "Setting up the hostnames on master server"
	echo >> /etc/hosts
	echo "192.168.133.100 UbuntuMaster" >> /etc/hosts
	echo "192.168.133.101 UbuntuSlaveA" >> /etc/hosts
	echo "192.168.133.102 UbuntuSlaveB" >> /etc/hosts
	echo "192.168.133.103 UbuntuSlaveC" >> /etc/hosts
	echo "Installing nfs-server and portmap master"
	sudo apt-get install nfs-kernel-server portmap
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
	mkdir mirror
	echo "Modifying permissions for mirror folder" 
	sudo chown nobody:nogroup /mirror
	echo "Modifying exports file"
	echo "/mirror *(rw,sync)" | sudo tee -a /etc/exports
	sudo service nfs-kernel-server restart
	echo "Installing SSH Server"
	sudo apt-get install openssh server
	echo "Setting up passwordless SSH for communication between nodes"
	ssh-keygen -t rsa
	echo "Next, we add this key to authorized keys:"
	cd .ssh
	cat id_rsa.pub >> authorized_keys
	ssh-copy-id blake@UbuntuSlaveA
	ssh-copy-id blake@UbuntuSlaveB
	ssh-copy-id blake@UbuntuSlaveC
	echo "setting up mpich2"
	cd /mirror
	wget http://www.mpich.org/static/downloads/1.5rc3/mpich2-1.5rc3.tar.gz
	tar -xf mpich2-1.5rc3.tar.gz
	mkdir mpich2
	cd mpich2-1.5rc3
	./configure --prefix=/mirror/mpich2/ --disable-f77 --disable-fc
	make 
	make install
	cd ..
	git clone https://github.com/ehab-abdelhamid/ScaleMine.git
	git clone https://github.com/zakimjz/DistGraph.git
elif [ "$Computer_Name" = "UbuntuSlaveA" ]
then 
	echo "Setting up the hostnames on slave server"
	echo >> /etc/hosts
	echo "192.168.133.100 UbuntuMaster" >> /etc/hosts
	echo "192.168.133.101 UbuntuSlaveA" >> /etc/hosts
	echo "192.168.133.102 UbuntuSlaveB" >> /etc/hosts
	echo "192.168.133.103 UbuntuSlaveB" >> /etc/hosts
	echo "Installing nfs-client on slave"
	sudo apt-get install nfs-common portmap
	echo "Updating the slaves interfaces"
	# The host-only network interface host ub1
	echo  >> /etc/network/interfaces
	echo "auto eth1" >> /etc/network/interfaces
	echo "iface eth1 inet static" >> /etc/network/interfaces
	echo "address 192.168.133.101" >> /etc/network/interfaces
	echo "netmask 255.255.255.0" >> /etc/network/interfaces
	echo "network 192.168.133.0" >> /etc/network/interfaces
	echo "broadcast 192.168.133.255" >> /etc/network/interfaces
	ssh-copy-id blake@UbuntuMaster
	ssh-copy-id blake@UbuntuSlaveB
	ssh-copy-id blake@UbuntuSlaveC
	# editing the fstab file
	echo "Editing the fstab file"
	echo "UbuntuMaster:/mirror    /mirror    nfs" >> /etc/fstab
elif [ "$Computer_Name" = "UbuntuSlaveB" ]
then
	echo "Setting up the hostnames on slave server"
	echo >> /etc/hosts
	echo "192.168.133.100 UbuntuMaster" >> /etc/hosts
	echo "192.168.133.101 UbuntuSlaveA" >> /etc/hosts
	echo "192.168.133.102 UbuntuSlaveB" >> /etc/hosts
	echo "192.168.133.103 UbuntuSlaveC" >> /etc/hosts
	echo "Installing nfs-client on slave"
	sudo apt-get install nfs-common portmap
	echo "Updating the slaves interfaces"
	# The host-only network interface host ub2
	echo  >> /etc/network/interfaces
	echo "auto eth1" >> /etc/network/interfaces
	echo "iface eth1 inet static" >> /etc/network/interfaces
	echo "address 192.168.133.102" >> /etc/network/interfaces
	echo "netmask 255.255.255.0" >> /etc/network/interfaces
	echo "network 192.168.133.0" >> /etc/network/interfaces
	echo "broadcast 192.168.133.255" >> /etc/network/interfaces
	ssh-copy-id blake@UbuntuMaster
	ssh-copy-id blake@UbuntuSlaveA
	ssh-copy-id blake@UbuntuSlaveC
	# editing the fstab file
	echo "Editing the fstab file"
	echo "UbuntuMaster:/mirror    /mirror    nfs" >> /etc/fstab
elif [ "$Computer_Name" = "UbuntuSlaveC" ]
then
	echo "Setting up the hostnames on slave server"
	echo >> /etc/hosts
	echo "192.168.133.100 UbuntuMaster" >> /etc/hosts
	echo "192.168.133.101 UbuntuSlaveA" >> /etc/hosts
	echo "192.168.133.102 UbuntuSlaveB" >> /etc/hosts
	echo "192.168.133.103 UbuntuSlaveC" >> /etc/hosts
	echo "Installing nfs-client on slave"
	sudo apt-get install nfs-common portmap
	echo "Updating the slaves interfaces"
	# The host-only network interface host ub3
	echo  >> /etc/network/interfaces
	echo "auto eth1" >> /etc/network/interfaces
	echo "iface eth1 inet static" >> /etc/network/interfaces
	echo "address 192.168.133.103" >> /etc/network/interfaces
	echo "netmask 255.255.255.0" >> /etc/network/interfaces
	echo "network 192.168.133.0" >> /etc/network/interfaces
	echo "broadcast 192.168.133.255" >> /etc/network/interfaces
	# mounting the commor folder shared amoung all nodes
	ssh-copy-id blake@UbuntuMaster
	ssh-copy-id blake@UbuntuSlaveA
	ssh-copy-id blake@UbuntuSlaveB
	# editing the fstab file
	echo "Editing the fstab file"
	echo "UbuntuMaster:/mirror    /mirror    nfs" >> /etc/fstab

fi
