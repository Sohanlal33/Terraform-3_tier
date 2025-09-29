terraform {
  backend "s3" {
    bucket         = "terraform-state-2032"  # must match s3.tf bucket name
    key            = "3tier/terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
  }
}

