provider "aws" {
  region = var.aws_region
}

# Datasource to get avaibility zones 
data aws_availability_zones "available" {
  state = "available"
}

#create a VPC
resource "aws_vpc" "project-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    name="project-vpc"
  }
}


#create a private subnet in the VPC
resource "aws_subnet" "private"{
    count = length(var.private_subnets)
    cidr_block = var.private_subnets[count.index]
    vpc_id = aws_vpc.project-vpc.id
    availability_zone = data.aws_availability_zones.available.names[count.index] 
    map_public_ip_on_launch = false
    tags = {
      name="project-privatesubnet"
    }
}

#create a public subnet in the VPC
resource "aws_subnet" "public"{
    count = length(var.public_subnets)
    cidr_block = var.public_subnets[count.index]
    vpc_id = aws_vpc.project-vpc.id
    availability_zone = data.aws_availability_zones.available.names[count.index]  
    map_public_ip_on_launch = true
    tags = {
      name="project-publicsubnet"
    }
}

#create a internet gateway in the VPC
resource "aws_internet_gateway" "project-vpc-igw" {
  vpc_id = aws_vpc.project-vpc.id
  tags = {
    name="project-vpc-igw"
  }
}

# NAT Gateway & Elastic IP (EIP)
# A NAT Gateway is required for private subnets to access the internet outbound
resource "aws_eip" "nat" {
  count = length(aws_subnet.public) # One EIP/NAT GW per Public Subnet
  domain = "vpc"
}
#create a nat gateway in the VPC
resource "aws_nat_gateway" "project-nat" {
    count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  depends_on = [aws_internet_gateway.project-vpc-igw]
  allocation_id = aws_eip.nat[count.index].id
  tags = {
    Name  = "project-nat"
    
  }
}

#create a private route table in the VPC
resource "aws_route_table" "private" {
    count  = length(aws_subnet.private)
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project-nat[count.index].id
  }
  tags = {
    name="project-private-routetable"
  }
}


#create a public route table in the VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-vpc-igw.id
  }
  tags = {
    name="project-public-routetable"
  }
}

#create a route table association in the VPC for public subnet
resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public)
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[count.index].id 
}

#create a route table association in the VPC for private subnet 
resource "aws_route_table_association" "private" {
    count = length(aws_subnet.private)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id = aws_subnet.private[count.index].id
}
