# Output variable definitions

output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "web_security_group_ids" {
  value = concat([aws_security_group.ssh.id])
}

output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}


#output "ec2_instance_public_ips" {
#  description = "Public IP addresses of EC2 instances"
#  value       = module.ec2_instance.public_ips
#}


##Error: Unsupported attribute
#│
#│#   on Output.tf line 10, in output "ec2_instance_public_ips":
#│ #  10:   value       = module.ec2_instance.public_ips
#│  #   ├────────────────
#│   #  │ module.ec2_instance is object with no attributes
#│
#│ This object does not have an attribute named "public_ips".