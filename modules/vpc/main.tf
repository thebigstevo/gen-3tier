# Purpose: Create a VPC with 3 public and 3 private subnets
resource "aws_vpc" "gen-3tier" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "gen-3tier"
  }
}

#Fetch available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.gen-3tier.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-${count.index + 1}"
    Tier = "Public"
    AZ   = local.azs[count.index]
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.gen-3tier.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "Private-Subnet-${count.index + 1}"
    Tier = "Private"
    AZ   = local.azs[count.index]
  }
}

