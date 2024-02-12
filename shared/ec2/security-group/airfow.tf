resource "aws_security_group" "airflow_sg" {
  name        = "${local.service_name_prefix}-airflow-sg"
  description = "airflow security group"
  vpc_id      = data.aws_vpc.selected.id
  tags        = merge(local.common_tags, tomap({ "Name" : "${local.service_name_prefix}-airflow-sg" }))



  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [data.aws_security_group.vpc_endpoint.id]
    description     = "Allow traffic to VPC Endpoints"
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    prefix_list_ids = [
      data.aws_ec2_managed_prefix_list.s3_prefix.id
    ]
    description = "Allow traffic to S3 Endpoints"
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.database : s.cidr_block]
    description = "Access RDS MySql Aurora via airflow Server"
  }

  dynamic "egress" {
    for_each = local.workspace["security_group"]["airflow"]["outbound"]
    iterator = each
    content {
      description     = each.value["description"]
      from_port       = each.value["from_port"]
      to_port         = each.value["to_port"]
      protocol        = each.value["protocol"]
      cidr_blocks     = contains(keys(each.value), "cidr_blocks") ? each.value["cidr_blocks"] : []
      security_groups = contains(keys(each.value), "security_groups") ? each.value["security_groups"] : []
      prefix_list_ids = contains(keys(each.value), "prefix_list_ids") ? each.value["prefix_list_ids"] : []
    }
  }
  dynamic "ingress" {
    for_each = local.workspace["security_group"]["airflow"]["inbound"]
    iterator = each
    content {
      description     = each.value["description"]
      from_port       = each.value["from_port"]
      to_port         = each.value["to_port"]
      protocol        = each.value["protocol"]
      cidr_blocks     = contains(keys(each.value), "cidr_blocks") ? each.value["cidr_blocks"] : []
      security_groups = contains(keys(each.value), "security_groups") ? each.value["security_groups"] : []
      prefix_list_ids = contains(keys(each.value), "prefix_list_ids") ? each.value["prefix_list_ids"] : []
    }
  }

}

