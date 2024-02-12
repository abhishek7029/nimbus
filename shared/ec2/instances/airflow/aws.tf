terraform {
  backend "s3" {
    bucket  = "prod-terraform-bucket-aspen"
    key     = "shared-services/ec2/instances/airflow/main.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "aspen"
  }
}

data "terraform_remote_state" "iam_role" {
  backend   = "s3"
  workspace = local.workspace_common["environment"]

  config = {
    bucket  = "prod-terraform-bucket-aspen"
    encrypt = true
    key     = "shared-services/iam/main.tfstate"
    region  = "us-east-1"
    profile = "aspen"
  }
}

data "terraform_remote_state" "security_group" {
  backend   = "s3"
  workspace = local.workspace_common["environment"]

  config = {
    bucket  = "prod-terraform-bucket-aspen"
    encrypt = true
    key     = "shared-services/ec2/security-group/main.tfstate"
    region  = "us-east-1"
    profile = "aspen"
  }
}
