environment = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

instance_type = "t3.micro"

db_instance_class = "db.t3.micro"

s3_bucket_name = "tf-assign-dev-app-bucket-12345"
