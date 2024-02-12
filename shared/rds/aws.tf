terraform {
  backend "s3" {
    bucket  = "prod-terraform-bucket-aspen"
    key     = "shared-services/rds/main.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "aspen"
  }
}