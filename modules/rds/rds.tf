resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "tier-subnet-group"
  subnet_ids = [aws_subnet.private_db_a.id, aws_subnet.private_db_b.id]
  tags = merge(var.tags, { Name = "tier-subnet-group" })
}

resource "aws_db_instance" "mysql" {
  identifier              = var.rds_identifier
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.rds_instance_type
  username                = var.rds_username
  password                = var.rds_password
  allocated_storage       = var.rds_allocated_storage
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  tags = merge(var.tags, { Name = "rds-mysql" })
}

