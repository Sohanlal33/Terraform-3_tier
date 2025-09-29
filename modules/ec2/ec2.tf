resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = aws_subnet.public_a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.bastion_key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  tags = merge(var.tags, { Name = "bastion" })
  count = var.bastion_ami != "" ? 1 : 0   # create only if AMI provided
}
