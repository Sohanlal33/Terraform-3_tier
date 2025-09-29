# Outputs from EC2 module

# Launch Template IDs
output "web_lt_id" {
  description = "Launch Template ID for Web servers"
  value       = aws_launch_template.web.id
}

output "app_lt_id" {
  description = "Launch Template ID for App servers"
  value       = aws_launch_template.app.id
}

# ASG Names (optional, useful for monitoring or scaling references)
output "web_asg_name" {
  description = "Web Auto Scaling Group name"
  value       = aws_autoscaling_group.web.name
}

output "app_asg_name" {
  description = "App Auto Scaling Group name"
  value       = aws_autoscaling_group.app.name
}

