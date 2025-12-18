environment = "prod"

vpc_cidr = "10.1.0.0/16"

public_subnets = [
  "10.1.1.0/24",
  "10.1.2.0/24"
]

private_subnets = [
  "10.1.3.0/24",
  "10.1.4.0/24"
]

instance_type = "t3.small"

db_instance_class = "db.t3.small"

s3_bucket_name = "tf-assign-prod-app-bucket-12345"
