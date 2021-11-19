resource_tags = {
  project     = "AWS_Lab1",
  environment = "dev",
  owner       = "tennyson.m.george@gmail.com"
}

ec2_instance_type = "t3.micro"

instance_count = 3

region = "us-west-1"

vpc_public_subnets = "10.100.1.0/24"

vpc_private_subnets = "10.100.0.0/24"

