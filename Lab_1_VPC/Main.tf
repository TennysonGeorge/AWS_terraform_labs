terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"
  # insert the 21 required variables here

  name = var.vpc_name
  cidr = var.vpc_cidr
  azs  = data.aws_availability_zones.available.names
  ### on The AZ, I'm using data source instead of the variable for AZ 
  #azs               = var.vpc_azs
  private_subnets    = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)
  public_subnets     = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_count)
  enable_nat_gateway = var.vpc_enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
  tags = var.resource_tags
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.2.0"
  # insert the 34 required variables here

  #for_each = toset(["one", "two"])
  ## if adding count, take out the for_each
  #name = "instance-${each.key}"
  ## the ${each.key} work only with the for_each function

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.ssh_key.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ssh.id]
  #subnet_id              = each.value
  #for_each               = data.aws_subnet_ids.each.value
  subnet_id = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  count     = var.instances_per_subnet * length(module.vpc.private_subnets)

}


### Security_group for the instance 


resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow shh inbound traffic"
  vpc_id      = "vpc-00d0f0dd6b89eaa37" ##This is an issue, maybe have something to do with terraform dependence 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh"
  }
}


#### Generate a new SSH key called ssh-key. The argument provided with the -f flag creates the key in the current directory and creates two files called ssh_key and ssh_key.pub. 
#### Change the placeholder email address to your email address.
##   ssh-keygen -C "tennyson.m.george@gmail.com" -f ssh_key.pem
### Create a new aws_key_pair resource to add to the newly created SSH key to the instance.

resource "aws_key_pair" "ssh_key" {
  key_name = "ssh_key"
  public_key = file("ssh_key.pem")
}


#### Query data sources from the provider 

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

