# Bastion SG
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.corp_vpc.id
  name   = "Corp-Bastion-SG"
  ingress { from_port = 22 to_port = 22 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  egress  { from_port = 0  to_port = 0  protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

# Web ALB SG
resource "aws_security_group" "web_alb_sg" {
  vpc_id = aws_vpc.corp_vpc.id
  name   = "Corp-WebALB-SG"
  ingress { from_port = 80  to_port = 80  protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  egress  { from_port = 0  to_port = 0  protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

# Web Server SG
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.corp_vpc.id
  name   = "Corp-WebServer-SG"
  ingress { from_port = 80  to_port = 80  protocol = "tcp" security_groups = [aws_security_group.web_alb_sg.id] }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" security_groups = [aws_security_group.web_alb_sg.id] }
  ingress { from_port = 22  to_port = 22  protocol = "tcp" security_groups = [aws_security_group.bastion_sg.id] }
  egress  { from_port = 0  to_port = 0  protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

# App ALB SG
resource "aws_security_group" "app_alb_sg" {
  vpc_id = aws_vpc.corp_vpc.id
  name   = "Corp-AppALB-SG"
  ingress { from_port = 80 to_port = 80 protocol = "tcp" security_groups = [aws_security_group.web_sg.id] }
  ingress { from_port = 443 to_port = 443 protocol = "tcp" security_groups = [aws_security_group.web_sg.id] }
  egress  { from_port = 0  to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

# App Server SG
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.corp_vpc.id
  name   = "Corp-AppServer-SG"
  ingress { from_port = 3200 to_port = 3200 protocol = "tcp" security_groups = [aws_security_group.app_alb_sg.id] }
  ingress { from_port = 22   to_port = 22   protocol = "tcp" security_groups = [aws_security_group.bastion_sg.id] }
  egress  { from_port = 0    to_port = 0    protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

# DB SG
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.corp_vpc.id
  name   = "Corp-DB-SG"
  ingress { from_port = 3306 to_port = 3306 protocol = "tcp" security_groups = [aws_security_group.app_sg.id, aws_security_group.bastion_sg.id] }
  egress  { from_port = 0    to_port = 0    protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}
