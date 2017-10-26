variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-1"
}

variable "aws_access_key" {
  default = "REPLACE_ME"
}

variable "aws_secret_key" {
  default = "REPLACE_ME"
}

# ubuntu-xenial-16.04 (x64)
variable "aws_amis" {
  default = {
    "eu-west-1" = "ami-785db401"
  }
}

variable "availability_zones" {
  default     = "eu-west-1a,eu-west-1b,eu-west-1c"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "subnets" {
  default     = "REPLACE_ME,REPLACE_ME,REPLACE_ME"
  description = "List of subnets zones, use AWS CLI to find your "
}

variable "key_name" {
  description = "Name of AWS key pair"
  default = "REPLACE_ME"
}

variable "instance_type_node" {
  default     = "t2.small"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "3"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "3"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "3"
}

variable "aws_security_group_ec2" {
  description = "Lan-Only Security Group"
  default     = "REPLACE_ME"
}

variable "aws_security_group_elb" {
  description = "Lan-Only Security Group"
  default     = "REPLACE_ME"
}

variable "aws_security_group_elb_jenkins" {
  description = "ELB Jenkins Security Group"
  default     = "REPLACE_ME"
}