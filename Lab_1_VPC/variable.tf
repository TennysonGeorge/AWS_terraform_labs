
variable "region" {
  description = "Name of region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "LAB_1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.100.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1c"]
}

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default = [
    "10.100.1.0/24",
    "10.100.2.0/24",
    "10.100.3.0/24",
    "10.100.4.0/24",
    "10.100.5.0/24",
    "10.100.6.0/24",
    "10.100.7.0/24",
    "10.100.8.0/24",
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "10.100.101.0/24",
    "10.100.102.0/24",
    "10.100.103.0/24",
    "10.100.104.0/24",
    "10.100.105.0/24",
    "10.100.106.0/24",
    "10.100.107.0/24",
    "10.100.108.0/24",
  ]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable a VPN gateway in your VPC."
  type        = bool
  default     = false
}


variable "instances_per_subnet" {
  description = "Number of EC2 instances in each private subnet"
  type        = number
  default     = 2
}

variable "instance_count" {
  description = "Number of EC2 instances in each  subnet"
  type        = number
  default     = 2
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {
    project     = "project-alpha",
    environment = "dev"
  }
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type."
  type        = string
}