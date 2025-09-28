# VPC and Subnet CIDRs
variable "vpc_cidr" { default = "192.168.0.0/16" }
variable "public_subnet_1a" { default = "192.168.1.0/24" }
variable "public_subnet_1b" { default = "192.168.2.0/24" }
variable "private_web_1a" { default = "192.168.3.0/24" }
variable "private_web_1b" { default = "192.168.4.0/24" }
variable "private_app_1a" { default = "192.168.5.0/24" }
variable "private_app_1b" { default = "192.168.6.0/24" }
variable "private_db_1a" { default = "192.168.7.0/24" }
variable "private_db_1b" { default = "192.168.8.0/24" }

# Bastion EC2
variable "bastion_instance_type" { default = "t2.micro" }
variable "bastion_key_name" { default = "" }  # SSH key
