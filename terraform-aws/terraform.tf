provider "aws" {
    access_key = "<insert_access_key_here>"
    secret_key = "<insert_secret_key_here>"
    region = "us-east-1"
}

resource "aws_instance" "devops-kickstart" {
    ami = "ami-408c7f28"
    instance_type = "t1.micro"
    key_name      = "kickstart"
}