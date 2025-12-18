#PHASE 1 => VPC

#Availibility zone variable
variable "aws_region" {
    description = "The AWS region for project deployment"
    type = string
    default = "ap-south-1"
}

#VPC configuration CIDR,Subnets,IGW, NAT
variable "vpc_cidr" {
  description = "The CIDR block for vpc"
}

# Define the Private Subnet CIDR blocks
variable "private_subnets" {
  description = " CIDR blocks for the private subnets."
  #type        = string
  #default     = "10.0.1.0/24"
}

# Define the Public Subnet CIDR blocks
variable "public_subnets" {
  description = "CIDR blocks for the public subnets."
  #type        = string
  #default     = "10.0.2.0/24"
}

