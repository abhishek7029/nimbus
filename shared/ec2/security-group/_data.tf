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

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${local.service_name_prefix}-private-*"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Scope"
    values = ["private"]
  }
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

data "aws_subnets" "database" {
  filter {
    name   = "tag:Name"
    values = ["${local.service_name_prefix}-database-*"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Scope"
    values = ["database"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnet" "app_tools" {
  for_each = toset(data.aws_subnets.app_tools.ids)
  id       = each.value
}

data "aws_subnet" "database" {
  for_each = toset(data.aws_subnets.database.ids)
  id       = each.value
}

data "aws_security_group" "vpc_endpoint" {
  tags = {
    Name    = "${local.service_name_prefix}-vpc-sg"
    Project = local.common["tags"]["Project"]
  }
  filter {
    name   = "tag:Scope"
    values = ["VPC"]
  }
  vpc_id = data.aws_vpc.selected.id
}

data "aws_ec2_managed_prefix_list" "s3_prefix" {
  name = "com.amazonaws.${local.workspace_aws["region"]}.s3"
}


data "aws_security_group" "rds_sg" {
  tags = {
    Name    = "${local.service_name_prefix}-mysql-*-sg"
    Project = local.common["tags"]["Project"]
  }
  filter {
    name   = "tag:Scope"
    values = ["RDS"]
  }
  vpc_id = data.aws_vpc.selected.id
}