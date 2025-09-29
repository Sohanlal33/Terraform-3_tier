terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = var.backend_s3_bucket
    key    = "terraform.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}
}
