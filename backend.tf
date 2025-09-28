terraform {
  backend "s3" {
    bucket         = "terraform-state-2032"
    key            = "3tier-infra/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
