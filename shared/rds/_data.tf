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

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
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

data "aws_subnet" "database" {
  for_each = toset(data.aws_subnets.database.ids)
  id       = each.value
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

data "aws_subnet" "app_tools" {
  for_each = toset(data.aws_subnets.app_tools.ids)
  id       = each.value
}
