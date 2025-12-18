This project provisions a small multi-tier AWS environment using Terraform, following common industry best practices.
The goal is to demonstrate how networking, compute, load balancing, database, storage, IAM, and observability components work together in a secure and scalable architecture.

The infrastructure is intentionally kept Free Tier–compatible while still reflecting real-world design patterns such as private networking, least-privilege IAM, and modular Terraform code.

## 1. Architecture Overview

Internet
   |
   v
Application Load Balancer (Public Subnets)
   |
   v
Auto Scaling Group (EC2 in Private Subnets)
   |
   v
PostgreSQL RDS (Private Subnets)

Supporting Services:
- S3 (application artifacts)
- IAM (roles and policies)
- CloudWatch (logs, metrics, alarms)

## 2. Networkings

Design Decisions

- VPC CIDR: A /16 CIDR block is used to allow enough IP space for future growth.
- Public Subnets (2):  Used only for the Application Load Balancer.
- Private Subnets (2): Used for EC2 instances and the RDS database.
- Availability Zones : Subnets are spread across multiple AZs to improve availability.
- Routing: Internet Gateway attached to the VPC.
- NAT Gateway placed in public subnets for outbound internet access from private subnets.
- ALB is public.
- EC2 and RDS are private.

## 3. Compute & Load Balancing
- Launch Template: Defines AMI, instance type, security groups, user data, and IAM instance profile.
- Auto Scaling Group
    Minimum: 1 instance
    Desired: 2 instances
    Maximum: 3 instances
- Provides high availability and self-healing.
- User Data
    Installs Apache HTTP server.
    Serves a simple HTML page to verify the application is running.
- Load Balancer
    Application Load Balancer (ALB)
    Listens on port 80
    Routes traffic to EC2 instances via a target group.

## 4. Database (RDS)
- Engine: PostgreSQL
- Instance Class: db.t3.micro (Free Tier eligible)
- Subnet Placement: Private subnets only
- Connectivity Model:
    Database is accessible only from EC2 security group.
- Password Handling:
    Credentials stored in AWS Secrets Manager
    No plaintext passwords in Terraform code or tfvars.

## 5. Storage (S3)
- Private S3 bucket for application-related files/artifacts.
- Public access fully blocked.
- Server-side encryption enabled (SSE-S3).
- Versioning enabled.

## 6. IAM (Security & Least Privilege)
- No IAM users or access keys.
- EC2 instances assume an IAM role via an instance profile.
- Permissions granted:
    Read access to the specific Secrets Manager secret.
    Limited access to a single S3 bucket.
    CloudWatch logging permissions.

## 7. 6. Observability
- Logging
    CloudWatch Logs for application and system logs.
- Metrics
    Native CloudWatch metrics for:
        EC2 CPU utilization
        ALB request counts and error rates
        RDS CPU and storage metrics
- Alerts (Optional)
    CloudWatch alarms for:
        High EC2 CPU usage
        ALB target 5XX errors

## 8. Terraform Structure
tf-assign-module/
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── outputs.tf
├── env/
│   ├── dev.tfvars
│   └── prod.tfvars
└── modules/
    ├── vpc/
    ├── compute/
    ├── rds/
    ├── s3/
    ├── iam/
    └── observability/

## 9. Environments
- Chosen Approach: Separate tfvars files
- Two environments are supported:
    - dev
    - prod
- Each environment has its own:
        CIDR ranges
        Instance sizes
        Database class
        S3 bucket name

## Usage
terraform apply -var-file=env/dev.tfvars
terraform apply -var-file=env/prod.tfvars

## Deploy
terraform init
terraform validate
terraform plan -var-file=env/dev.tfvars
terraform apply -var-file=env/dev.tfvars

## Destroy
terraform destroy -var-file=env/dev.tfvars