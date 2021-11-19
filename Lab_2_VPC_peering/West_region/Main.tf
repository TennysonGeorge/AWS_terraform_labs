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

  azs             = var.vpc_azs
  private_subnets = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  public_subnets  = ["10.100.101.0/24", "10.100.102.0/24", "10.100.103.0/24"]
  ### The "terraform validate" is successfully after you comment out the private and public subnet var, and hardcode it instead
  #private_subnets = var.vpc_private_subnets
  #public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "ec2_instance" {
 source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.2.0"
  # insert the 34 required variables here

  for_each = toset(["one", "two"])
  name     = "instance-${each.key}"
 
  ami                    = "ami-0bdb828fd58c52235"
  instance_type          = "t2.micro"
  ## This keypair that I gave it, didn't work, I had to comment it before it work. When it work, it give you a ramdom keypair
  #key_name               = "on_win.pem"
  monitoring             = true
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
