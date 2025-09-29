#########################################################
# VPC Module
#########################################################
module "vpc" {
  source              = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_1a    = var.public_subnet_1a
  public_subnet_1b    = var.public_subnet_1b
  private_web_1a      = var.private_web_1a
  private_web_1b      = var.private_web_1b
  private_app_1a      = var.private_app_1a
  private_app_1b      = var.private_app_1b
  private_db_1a       = var.private_db_1a
  private_db_1b       = var.private_db_1b
  tags                = var.tags
}

#########################################################
# EC2 Module (Bastion + App + Web)
#########################################################
module "ec2" {
  source                = "./modules/ec2"

  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnet_ids
  private_web_subnets   = module.vpc.private_web_subnet_ids
  private_app_subnets   = module.vpc.private_app_subnet_ids

  # Bastion
  bastion_key_name      = var.bastion_key_name
  bastion_ami           = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type

  # App servers
  app_ami               = var.app_ami
  app_instance_type     = var.app_instance_type

  # Web servers
  web_ami               = var.web_ami
  web_instance_type     = var.web_instance_type

  tags                  = var.tags
}

#########################################################
# ALB Module
#########################################################
module "alb" {
  source                = "./modules/alb"

  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnet_ids
  private_app_subnets   = module.vpc.private_app_subnet_ids
  private_web_subnets   = module.vpc.private_web_subnet_ids
  tags                  = var.tags
}

#########################################################
# Auto Scaling Module
#########################################################
module "asg" {
  source                = "./modules/asg"

  app_subnets           = module.vpc.private_app_subnet_ids
  web_subnets           = module.vpc.private_web_subnet_ids
  app_tg_arn            = module.alb.app_tg_arn
  web_tg_arn            = module.alb.web_tg_arn
  app_lt_id             = module.ec2.app_lt_id
  web_lt_id             = module.ec2.web_lt_id

  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  tags                  = var.tags
}

#########################################################
# RDS Module
#########################################################
module "rds" {
  source                = "./modules/rds"

  db_subnets            = module.vpc.private_db_subnet_ids
  db_instance_type      = var.rds_instance_type
  db_username           = var.rds_username
  db_password           = var.rds_password
  db_identifier         = var.rds_identifier
  tags                  = var.tags
}

#########################################################
# IAM Module
#########################################################
module "iam" {
  source = "./modules/iam"
}

#########################################################
# S3 Module
#########################################################
module "s3" {
  source       = "./modules/s3"
  bucket_name  = var.backend_s3_bucket
  tags         = var.tags
}

