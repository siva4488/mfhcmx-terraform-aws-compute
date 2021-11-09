terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

variable "os_type" {}

provider "aws" {
  # Configuration options
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  profile = "default"
  region  = "${var.region}"
}

data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name = "opt-in-status"
    values = ["opt-in-not-required"]
   }
}

resource "aws_instance" "default" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair}"
  subnet_id = "${var.subnet_id}"
  ebs_block_device {
      device_name = "/dev/sdb"
      volume_size = "${var.volume_size}"
      volume_type = "${var.volume_type}"
      delete_on_termination = "true"
                  }
  tags = {
  Owner = "Siva"
  Name = "${var.instance_name}"}
  }

resource "aws_security_group" "default" {
  name        = "${var.sgname}"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${var.vpc_id}"
  
    ingress = [
    {
      description      = "Allow SSH Port"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]
 
  tags = {
    Owner = "Siva"
    Name = "${var.instance_name}"
  }
}

data "aws_instance" "default" {
  instance_id = aws_instance.default.id
}

data "aws_network_interface" "default" {
  id = data.aws_instance.default.network_interface_id
}

data "aws_security_group" "default" {
  name = aws_security_group.default.instance.[0].name
}

data "aws_ebs_volume" "default" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }
}
