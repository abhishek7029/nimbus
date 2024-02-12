data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.service_name_prefix]
  }
  filter {
    name   = "tag:Scope"
    values = ["VPC"]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-arm64*"]
  }
  owners = ["amazon"]
}

data "aws_subnets" "app-tools" {
  filter {
    name   = "tag:Name"
    values = ["${local.service_name_prefix}-app-tools-*"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Scope"
    values = ["app-tools"]
  }
}