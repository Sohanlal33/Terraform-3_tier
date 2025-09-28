output "bastion_public_ip" { value = aws_instance.bastion_host.public_ip }
output "nat_eip" { value = aws_eip.nat_eip.public_ip }
