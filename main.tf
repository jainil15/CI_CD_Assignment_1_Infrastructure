terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Jainil-Org"
    workspaces {
      name = "ForAssignment"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  env = "dev"
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Ubuntu Server 22.04 LTS*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "ena-support"
    values = ["true"]
  }
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}
module "vpc" {

  source                    = "app.terraform.io/Jainil-Org/vpc/aws"
  version                   = "1.0.0"
  env                       = local.env
  vpc_cidr_block            = "12.88.0.0/16"
  azs                       = ["ap-south-1a"]
  public_subnet_cidr_blocks = ["12.88.0.64/26"]

}

module "instance" {
  source  = "app.terraform.io/Jainil-Org/instance/aws"
  version = "1.0.3"
  env     = local.env
  // ami_id             = data.aws_ami.ubuntu_ami.id
  ami_id             = "ami-03bb6d83c60fc5f7c"
  instance_type      = "t2.micro"
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  public_sg_ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    },
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  private_key = var.private_key
  user_data   = file("./docker_installation.sh")
}