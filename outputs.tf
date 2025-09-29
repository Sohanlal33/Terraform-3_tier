output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "private_app_subnet_ids" { value = module.vpc.private_app_subnet_ids }
output "bastion_public_ip" { value = module.ec2.bastion_public_ip }
output "web_alb_dns" { value = module.alb.web_alb_dns }
output "app_alb_dns" { value = module.alb.app_alb_dns }
output "rds_endpoint" { value = module.rds.rds_endpoint }

