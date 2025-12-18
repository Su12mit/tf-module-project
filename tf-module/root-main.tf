provider "aws" {
  region = "ap-south-1"
}
#Phase 1=> VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

#Phase 2=> ALB module
module "compute" {
  source = "./modules/compute"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_type      = var.instance_type
  instance_profile_name = module.iam.instance_profile_name
}


#Phase 3=> RDS module
module "rds" {
  source = "./modules/rds"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  allowed_sg_id      = module.compute.ec2_sg_id

  environment = var.environment
}


# Phase 4 => S3 module
module "s3" {
  source = "./modules/s3"
  bucket_name = var.s3_bucket_name
}

# Phase 5 => IAM module
module "iam" {
  source = "./modules/iam"

  s3_bucket_arn = module.s3.bucket_arn
  secret_arn    = module.rds.secret_arn
}

# Phase 6 => Observability
module "observability" {
  source = "./modules/observability"

  asg_name                = module.compute.asg_name
  alb_arn_suffix          = module.compute.alb_arn_suffix
  target_group_arn_suffix = module.compute.target_group_arn_suffix
}
