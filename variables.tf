
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

# Bastion EC2
variable "bastion_instance_type" {
  description = "EC2 instance type for Bastion host."
  default     = "t2.micro"
}

variable "bastion_key_name" {
  description = "SSH key name to connect to the Bastion host. Leave empty if not required."
  default     = ""
}

