# App target group (internal)
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tier-tg"
  port     = 3200
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path                = "/health"
    matcher             = "200-399"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 2
    timeout             = 5
  }
  tags = merge(var.tags, { Name = "app-tg" })
}

# Internal ALB for App tier
resource "aws_lb" "app_internal_alb" {
  name               = "app-tier-internal-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = [aws_subnet.private_app_a.id, aws_subnet.private_app_b.id]
  security_groups    = [aws_security_group.app_alb_sg.id]
  tags = merge(var.tags, { Name = "app-internal-alb" })
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_internal_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Web target group (external)
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path                = "/health"
    matcher             = "200-399"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 2
    timeout             = 5
  }
  tags = merge(var.tags, { Name = "web-tg" })
}

# External ALB for Web tier
resource "aws_lb" "web_external_alb" {
  name               = "web-tier-external-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_groups    = [aws_security_group.web_alb_sg.id]
  tags = merge(var.tags, { Name = "web-external-alb" })
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_external_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

