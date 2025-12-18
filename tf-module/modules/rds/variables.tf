variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

#Database variable
#DB name
variable "db_name" {
  type    = string
  default = "app_db"
}

#DB usename
variable "db_username" {
  type    = string
  default = "dbadmin"
}

#DB Instance
variable "db_instance" {
  type    = string
  default = "db.t3.micro"
}

variable "allowed_sg_id" {
  description = "Security group ID allowed to access DB (EC2 SG)"
  type        = string
}

variable "environment" {
  type = string
}
