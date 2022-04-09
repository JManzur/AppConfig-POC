# VPC Definition
resource "aws_vpc" "poc_vpc" {
  cidr_block           = "10.48.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}" }, )
}

# Public Subnet
resource "aws_subnet" "poc_public" {
  vpc_id            = aws_vpc.poc_vpc.id
  cidr_block        = "10.48.10.0/24"
  availability_zone = "${var.AWSRegion}a"

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-public" }, )
}

# Private Subnet
resource "aws_subnet" "poc_private" {
  vpc_id            = aws_vpc.poc_vpc.id
  cidr_block        = "10.48.20.0/24"
  availability_zone = "${var.AWSRegion}a"

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-private" }, )
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.poc_vpc.id

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-gw" }, )
}

# EIP for NAT Gateway
resource "aws_eip" "nat_gateway" {
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.poc_public.id

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-ngw" }, )
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.poc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-rt" }, )
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.poc_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-rt" }, )
}

# Public Subnets Association
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.poc_public.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Subnets Association
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.poc_private.id
  route_table_id = aws_route_table.private_route_table.id
}