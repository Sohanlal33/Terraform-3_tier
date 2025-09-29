
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-tier-lt-"
  image_id      = var.app_ami             # <-- set var.app_ami
  instance_type = var.app_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(file("${path.module}/userdata/app-tier-user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, { Name = "app-instance" })
  }
}

# Web Launch Template (nginx reverse proxy)
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-tier-lt-"
  image_id      = var.web_ami             # <-- set var.web_ami
  instance_type = var.web_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.web_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(file("${path.module}/userdata/web-tier-user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, { Name = "web-instance" })
  }
}

