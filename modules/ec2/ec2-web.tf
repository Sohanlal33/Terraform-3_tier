resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-web-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile { name = aws_iam_instance_profile.ec2_role.name }
  security_group_names = [aws_security_group.web_sg.name]
  user_data           = file("${path.module}/../../userdata/web-tier-user-data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${var.project_name}-web" }
  }
}

resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check { path = "/health" matcher = "200-399" interval = 30 unhealthy_threshold = 2 healthy_threshold = 2 timeout = 5 }
}

resource "aws_lb" "web_external" {
  name               = "${var.project_name}-web-external-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_alb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web_external.arn
  port              = 80
  protocol          = "HTTP"
  default_action { type = "forward" target_group_arn = aws_lb_target_group.web.arn }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.private_web_a.id, aws_subnet.private_web_b.id]
  launch_template { id = aws_launch_template.web.id version = "$Latest" }
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 30
  tag { key = "Name" value = "${var.project_name}-web-asg" propagate_at_launch = true }
}

