data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Definition
resource "aws_vpc" "poc_vpc" {
  cidr_block           = var.vpcCidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}" }, )
}

# VPC Flow Logs
resource "aws_flow_log" "VpcFlowLog" {
  iam_role_arn    = aws_iam_role.vpc_fl_policy_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.poc_vpc.id
}

# Public Subnets
resource "aws_subnet" "poc_public" {
  for_each                = { for i, v in var.PublicSubnet-List : i => v }
  vpc_id                  = aws_vpc.poc_vpc.id
  cidr_block              = cidrsubnet(var.vpcCidr, each.value.newbits, each.value.netnum)
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = true

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-${each.value.name}" }, )
}

# Public Subnets
resource "aws_subnet" "poc_private" {
  for_each          = { for i, v in var.PrivateSubnet-List : i => v }
  vpc_id            = aws_vpc.poc_vpc.id
  cidr_block        = cidrsubnet(var.vpcCidr, each.value.newbits, each.value.netnum)
  availability_zone = data.aws_availability_zones.available.names[each.value.az]

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-${each.value.name}" }, )
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.poc_vpc.id

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-gw" }, )
}

# Default Route Table
resource "aws_default_route_table" "publicRouteTable" {
  default_route_table_id = aws_vpc.poc_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-default-rt" }, )
}

# EIP for NAT Gateway
resource "aws_eip" "nat_gateway" {
  count = var.natCount
  vpc   = true
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.natCount
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.poc_public[count.index].id

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-ngw" }, )
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  count  = var.natCount
  vpc_id = aws_vpc.poc_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = merge(var.ProjectTags, { Name = "${var.vpcNameTag}-rt" }, )
}

# Private Subnets Association
resource "aws_route_table_association" "private" {
  count          = length(var.PrivateSubnet-List)
  subnet_id      = aws_subnet.poc_private[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}