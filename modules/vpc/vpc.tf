#########################################################
# VPC & Subnets
#########################################################

# Main VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "3tier-vpc" })
}

# Public Subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1a
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "public-subnet-1a" })
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1b
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "public-subnet-1b" })
}

# Private Subnets
resource "aws_subnet" "private_web_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_web_1a
  availability_zone = "${var.aws_region}a"

  tags = merge(var.tags, { Name = "private-web-1a" })
}

resource "aws_subnet" "private_web_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_web_1b
  availability_zone = "${var.aws_region}b"

  tags = merge(var.tags, { Name = "private-web-1b" })
}

resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_1a
  availability_zone = "${var.aws_region}a"

  tags = merge(var.tags, { Name = "private-app-1a" })
}

resource "aws_subnet" "private_app_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_1b
  availability_zone = "${var.aws_region}b"

  tags = merge(var.tags, { Name = "private-app-1b" })
}

resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_1a
  availability_zone = "${var.aws_region}a"

  tags = merge(var.tags, { Name = "private-db-1a" })
}

resource "aws_subnet" "private_db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_1b
  availability_zone = "${var.aws_region}b"

  tags = merge(var.tags, { Name = "private-db-1b" })
}

#########################################################
# Internet Gateway & NAT Gateway
#########################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "3tier-igw" })
}

resource "aws_eip" "nat_eip" {
  vpc  = true
  tags = merge(var.tags, { Name = "nat-eip" })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id
  tags          = merge(var.tags, { Name = "3tier-nat" })
}

#########################################################
# Route Tables
#########################################################

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, { Name = "public-rt" })
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(var.tags, { Name = "private-rt" })
}

# Associate Private Subnets
resource "aws_route_table_association" "private_web_a_assoc" {
  subnet_id      = aws_subnet.private_web_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_web_b_assoc" {
  subnet_id      = aws_subnet.private_web_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_app_a_assoc" {
  subnet_id      = aws_subnet.private_app_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_app_b_assoc" {
  subnet_id      = aws_subnet.private_app_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_a_assoc" {
  subnet_id      = aws_subnet.private_db_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_b_assoc" {
  subnet_id      = aws_subnet.private_db_b.id
  route_table_id = aws_route_table.private_rt.id
}

