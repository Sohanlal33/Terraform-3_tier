resource "aws_instance" "bastion_host" {
  ami                         = "ami-0c5199d385b432989" #change ami_id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.bastion_sg.name]
  key_name                    = var.bastion_key_name
  tags = { Name = "Corp-Bastion" }
}
