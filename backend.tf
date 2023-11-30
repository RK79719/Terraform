# backend.tf

terraform {
  backend "s3" {
    bucket         = "radha-terraform-state-store-bucket"
    key            = "asg-lb/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
  }
}