# General Settings
variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "ap-south-1"
}

variable "backend_s3_bucket" {
  description = "S3 bucket name for Terraform remote state (must exist or be created prior)."
  type        = string
  default     = "terraform-state-2032"
}

# VPC and Subnet CIDRs
variable "vpc_cidr" {
  description = "CIDR block for the main VPC."
  default     = "192.168.0.0/16"
}

variable "public_subnet_1a" {
  description = "CIDR block for Public Subnet 1a."
  default     = "192.168.1.0/24"
}

variable "public_subnet_1b" {
  description = "CIDR block for Public Subnet 1b."
  default     = "192.168.2.0/24"
}

variable "private_web_1a" {
  description = "CIDR block for Private Web Subnet 1a."
  default     = "192.168.3.0/24"
}

variable "private_web_1b" {
  description = "CIDR block for Private Web Subnet 1b."
  default     = "192.168.4.0/24"
}

variable "private_app_1a" {
  description = "CIDR block for Private App Subnet 1a."
  default     = "192.168.5.0/24"
}

variable "private_app_1b" {
  description = "CIDR block for Private App Subnet 1b."
  default     = "192.168.6.0/24"
}

variable "private_db_1a" {
  description = "CIDR block for Private DB Subnet 1a."
  default     = "192.168.7.0/24"
}

variable "private_db_1b" {
  description = "CIDR block for Private DB Subnet 1b."
  default     = "192.168.8.0/24"
}

# Bastion Host
variable "bastion_instance_type" {
  description = "EC2 instance type for Bastion host."
  default     = "t2.micro"
}

variable "bastion_key_name" {
  description = "SSH key pair name to connect to the Bastion host. Leave empty if not required."
  default     = ""
}

variable "bastion_ami" {
  description = "AMI ID for the Bastion host (replace with region-specific AMI)."
  default     = ""
}

# Application Servers
variable "app_instance_type" {
  description = "EC2 instance type for Application servers."
  default     = "t2.micro"
}

variable "app_ami" {
  description = "AMI ID for Application servers (replace with region-specific AMI)."
  default     = ""
}

# Web Servers
variable "web_instance_type" {
  description = "EC2 instance type for Web servers."
  default     = "t2.micro"
}

variable "web_ami" {
  description = "AMI ID for Web servers (replace with region-specific AMI)."
  default     = ""
}

# RDS Database
variable "rds_instance_type" {
  description = "Instance type for the RDS MySQL database."
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage size (in GB) for the RDS MySQL database."
  default     = 20
}

variable "rds_username" {
  description = "Master username for the RDS instance."
  default     = "admin"
}

variable "rds_password" {
  description = "Master password for the RDS instance (set via tfvars or SSM Parameter Store)."
  default     = ""
}

variable "rds_identifier" {
  description = "Identifier for the RDS instance."
  default     = "dev-db-instance"
}

# Auto Scaling
variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group."
  default     = 2
}

# Tags
variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "3-tier"
  }
}

