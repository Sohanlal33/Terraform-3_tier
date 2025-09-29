# Bastion SG
resource "aws_security_group" "bastion_sg" {
  name        = "Bastion-SG"
  description = "Allow SSH from anywhere (use your IP in prod)"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "Bastion-SG" })
}

# Web ALB SG (external)
resource "aws_security_group" "web_alb_sg" {
  name        = "WebALB-SG"
  description = "Allow HTTP/HTTPS from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "WebALB-SG" })
}

# Web Server SG
resource "aws_security_group" "web_sg" {
  name        = "Web-SG"
  description = "Allow HTTP/HTTPS from WebALB, SSH from Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }

  tags = merge(var.tags, { Name = "Web-SG" })
}

# App ALB SG (internal)
resource "aws_security_group" "app_alb_sg" {
  name        = "AppALB-SG"
  description = "Allow HTTP from Web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }

  tags = merge(var.tags, { Name = "AppALB-SG" })
}

# App Server SG
resource "aws_security_group" "app_sg" {
  name        = "App-SG"
  description = "Allow app port 3200 from AppALB; SSH from Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3200
    to_port         = 3200
    protocol        = "tcp"
    security_groups = [aws_security_group.app_alb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }

  tags = merge(var.tags, { Name = "App-SG" })
}

# Database SG
resource "aws_security_group" "db_sg" {
  name        = "DB-SG"
  description = "Allow MySQL from App-SG and Bastion-SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id, aws_security_group.bastion_sg.id]
  }

  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }

  tags = merge(var.tags, { Name = "DB-SG" })
}

