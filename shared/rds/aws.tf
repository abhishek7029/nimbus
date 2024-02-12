terraform {
  backend "s3" {
    bucket  = "nimbus-terraform-bucket"
    key     = "shared-services/rds/main.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}