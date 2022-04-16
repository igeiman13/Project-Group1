# - Defining the Provider
provider "aws" {
  region = "us-east-1"
}

# Data Source for Availability Zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define local tags
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
  name_prefix  = "${var.prefix}-${var.env}"
}

# Create VPC 
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-VPC"
    }
  )
}

# Add Public Subnets
resource "aws_subnet" "public_subnet" {
  count             = length (var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index+1]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-PublicSubnet-${count.index+1}"
    }
  )
}

# Add Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = length (var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index+1]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-PrivateSubnet-${count.index+1}"
    }
  )
}

# Create Internet Gateway - IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-IGW"
    }
  )
}

# Route Table for IGW
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name_prefix}-RouteTable_IGW"
  }
}


# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_for_nat_gateway.id
  subnet_id = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${local.name_prefix}-NAT_GW"
  }
}


# Elastic IP for NAT Gateway
resource "aws_eip" "eip_for_nat_gateway" {
  vpc = true
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-EIP"
    }
  )
}


# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${local.name_prefix}-RouteTable_NAT"
  }
}

# Associate Subnets with RouteTable

resource "aws_route_table_association" "public_route_table_association" {
  count          = length (var.public_subnet_cidrs)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length (var.public_subnet_cidrs)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}
