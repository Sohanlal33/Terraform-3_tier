# modules/alb/outputs.tf

output "web_tg_arn" {
  description = "ARN of the Web ALB Target Group"
  value       = aws_lb_target_group.web.arn
}

output "app_tg_arn" {
  description = "ARN of the App ALB Target Group"
  value       = aws_lb_target_group.app.arn
}

output "web_alb_dns" {
  description = "DNS name of the Web ALB"
  value       = aws_lb.web_external.dns_name
}

output "app_alb_dns" {
  description = "DNS name of the App ALB"
  value       = aws_lb.app_internal.dns_name
}

