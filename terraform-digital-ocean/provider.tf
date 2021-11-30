variable "ssh_fingerprint" {}  # SSH Fingerprint
variable "do_token" {}         # DigitalOcean token
variable "pub_key" {}          # Public Key to be installed in the DigitalOcean server
variable "pvt_key" {}          # Private Key Terraform uses to connect to the new server

provider "digitalocean" {
  token = "${var.do_token}"
}
