variable "ssh_fingerprint" {}  # SSH Fingerprint
variable "do_token" {}         # Your DigitalOcean token
variable "pub_key" {}          # Public Key to be installed in your DigitalOcean server
variable "pvt_key" {}          # Private Key Terraform will use to connect to your new server

provider "digitalocean" {
  token = "${var.do_token}"
}
