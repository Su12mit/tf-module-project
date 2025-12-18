variable "vpc_cidr" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "instance_type" {
  default = "t3.micro"
  type = string
}

variable "s3_bucket_name" {
  description = "S3 bucket for application artifacts"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

  
