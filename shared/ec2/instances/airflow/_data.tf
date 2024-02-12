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

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical account ID for Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}


data "aws_subnets" "app_tools" {
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