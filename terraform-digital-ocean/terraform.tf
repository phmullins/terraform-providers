# Digital Ocean Build Script
# Author: Patrick H. Mullins (pmullins11@gmail.com)
# Description: Creates a VPS, installs NGINX, and sets up DNS.
# Required: Laptop with Terraform and Ansible
# Created: 2018-08-16 - Modifed: 2018-12-06

# Choose from the following distros:
#
# centos-7-x64, centos-6-x64, centos-6-x32, centos-5-x64, centos-5-x32
# coreos-stable, coreos-beta, coreos-alpha
# debian-8-x64, debian-8-x32, debian-7-x64, debian-7-x32
# fedora-25-x64, fedora-24-x64, fedora-23-x64.
# freebsd-10-1-x64, freebsd-10-2-x64, freebsd-10-3-x64, freebsd-10-3-x64-zfs, freebsd-11-0-x64, reebsd-11-0-x64-zfs
# ubuntu-16-10-x64, ubuntu-16-10-x32,ubuntu-14-04-x64, ubuntu-14-04-x32, ubuntu-12-04-x64, ubuntu-12-04-x32

resource "digitalocean_droplet" "kickstarter" {
	image = "debian-8-x64"
	name = "kickstarter"
	region = "nyc2"
	size = "1024mb"
	private_networking = false
	ssh_keys = [
		"${var.ssh_fingerprint}"
	]

	# Setup SSH connection.
	
  	connection {
    	user = "root"
      	type = "ssh"
      	private_key = "${file(var.pvt_key)}"
      	timeout = "2m"
	}

	# Grab the IP of the droplet and create an Ansible hosts file.

	provisioner "local-exec" {
	    command = "echo ${digitalocean_droplet.kickstarter.ipv4_address} ansible_connection=ssh ansible_ssh_user=root >> db-hosts"
	}
  	
	# Create a new domain record.
	
		resource "digitalocean_domain" "default" {
   		name = "pmullins.net"
   		ip_address = "${digitalocean_droplet.kickstarter.ipv4_address}"
	}

	# Create CNAME resource for new domain.
	
		resource "digitalocean_record" "CNAME-www" {
  		domain = "${digitalocean_domain.default.name}"
  		type = "CNAME"
  		name = "www"
  		value = "@"
	}

	# Install NGINX, PHP, and PostgreSQL.

	provisioner "remote-exec" {
    	inline = [
      		"export PATH=$PATH:/usr/bin",
      		"sudo apt-get update",
      		"sudo apt-get -y install nginx postgresql postgresql-client",
      		"sudo apt-get -y install php7.0 php7.0-fpm php7.0-cli php7.0-curl php7.0-dev php7.0-xml php7.0-pgsql php7.0-mcrypt php7.0-mbstring php7.0-opcache"
    	]
  	}
	
}

