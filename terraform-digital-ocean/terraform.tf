# Digital Ocean Build Script
# Author: Patrick H. Mullins (pmullins11@mac.com)
# Description: Creates a VPS with 512MB of RAM, 1 2Ghz CPU, and a 20GB SSD
# Required: Laptop with Terraform and Ansible
# Created: 2016-08-16 - Modifed: 2016-12-06

# Choose from the following distros:
#
# centos-7-x64, centos-6-x64, centos-6-x32, centos-5-x64, centos-5-x32
# coreos-stable, coreos-beta, coreos-alpha
# debian-8-x64, debian-8-x32, debian-7-x64, debian-7-x32
# fedora-25-x64, fedora-24-x64, fedora-23-x64.
# freebsd-10-1-x64, freebsd-10-2-x64, freebsd-10-3-x64, freebsd-10-3-x64-zfs, freebsd-11-0-x64, reebsd-11-0-x64-zfs
# ubuntu-16-10-x64, ubuntu-16-10-x32,ubuntu-14-04-x64, ubuntu-14-04-x32, ubuntu-12-04-x64, ubuntu-12-04-x32

resource "digitalocean_droplet" "kickstarter" {
	image = "freebsd-10-3-x64-zfs"
	name = "kickstarter"
	region = "nyc2"
	size = "512mb"
	private_networking = false
	ssh_keys = [
		"${var.ssh_fingerprint}"
	]

# Grab the IP of the droplet and create an Ansible hosts file

	provisioner "local-exec" {
	    command = "echo ${digitalocean_droplet.kickstarter.ipv4_address} ansible_connection=ssh ansible_ssh_user=root >> db-hosts"
	}

}
