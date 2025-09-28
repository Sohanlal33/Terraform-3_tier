# VPC
resource "aws_vpc" "corp_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "CorpVPC" }
}

# Public Subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.corp_vpc.id
  cidr_block              = var.public_subnet_1a
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "Corp-Public-Subnet-A" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.corp_vpc.id
  cidr_block              = var.public_subnet_1b
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = { Name = "Corp-Public-Subnet-B" }
}

# Private Subnets
resource "aws_subnet" "private_web_a" { vpc_id = aws_vpc.corp_vpc.id cidr_block = var.private_web_1a availability_zone = "ap-south-1a" tags = { Name = "Corp-Private-Web-A" } }
resource "aws_subnet" "private_web_b" { vpc_id = aws_vpc.corp_vpc.id cidr_block = var.private_web_1b availability_zone = "ap-south-1b" tags = { Name = "Corp-Private-Web-B" } }
resource "aws_subnet" "private_app_a" { vpc_id = aws_vpc.corp_vpc.id cidr_block = var.private_app_1a availability_zone = "ap-south-1a" tags = { Name = "Corp-Private-App-A" } }
resource "aws_subnet" "private_app_b" { vpc_id = aws_vpc.corp_vpc.id cidr_block = var.private_app_1b availability_zone = "ap-south-1b" tags = { Name = "Corp-Private-App-B" } }
resource "aws_subnet" "private_db_a"  { vpc_id = aws_vpc.corp_vpc.id cidr_block = var.private_db_1a  availability_zone = "ap-south-1a" tags = { Name = "Corp-Private-DB-A" } }
resource "aws_subnet" "private_db_b"  { vpc_id = aws_vpc.corp_vpc.id cidr_block = var.private_db_1b  availability_zone = "ap-south-1b" tags = { Name = "Corp-Private-DB-B" } }

# Internet Gateway
resource "aws_internet_gateway" "corp_igw" { vpc_id = aws_vpc.corp_vpc.id tags = { Name = "Corp-IGW" } }

# NAT Gateway
resource "aws_eip" "nat_eip" { vpc = true }
resource "aws_nat_gateway" "corp_nat" { allocation_id = aws_eip.nat_eip.id subnet_id = aws_subnet.public_a.id }

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.corp_vpc.id
  route { cidr_block = "0.0.0.0/0" gateway_id = aws_internet_gateway.corp_igw.id }
}
resource "aws_route_table_association" "public_a_assoc" { subnet_id = aws_subnet.public_a.id route_table_id = aws_route_table.public_rt.id }
resource "aws_route_table_association" "public_b_assoc" { subnet_id = aws_subnet.public_b.id route_table_id = aws_route_table.public_rt.id }

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.corp_vpc.id
  route { cidr_block = "0.0.0.0/0" nat_gateway_id = aws_nat_gateway.corp_nat.id }
}
resource "aws_route_table_association" "private_web_a_assoc" { subnet_id = aws_subnet.private_web_a.id route_table_id = aws_route_table.private_rt.id }
resource "aws_route_table_association" "private_web_b_assoc" { subnet_id = aws_subnet.private_web_b.id route_table_id = aws_route_table.private_rt.id }
resource "aws_route_table_association" "private_app_a_assoc" { subnet_id = aws_subnet.private_app_a.id route_table_id = aws_route_table.private_rt.id }
resource "aws_route_table_association" "private_app_b_assoc" { subnet_id = aws_subnet.private_app_b.id route_table_id = aws_route_table.private_rt.id }
resource "aws_route_table_association" "private_db_a_assoc"  { subnet_id = aws_subnet.private_db_a.id  route_table_id = aws_route_table.private_rt.id }
resource "aws_route_table_association" "private_db_b_assoc"  { subnet_id = aws_subnet.private_db_b.id  route_table_id = aws_route_table.private_rt.id }
