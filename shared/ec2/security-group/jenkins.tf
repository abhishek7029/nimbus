resource "aws_security_group" "jenkins_sg" {
  name        = "${local.service_name_prefix}-jenkins-sg"
  description = "Jenkins security group"
  vpc_id      = data.aws_vpc.selected.id
  tags        = merge(local.common_tags, tomap({ "Name" : "${local.service_name_prefix}-jenkins-sg" }))

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Access EC2 Jenkins via VPN Server"
  }

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
    description = "Access RDS MySql Aurora via Jenkins Server"
  }

  dynamic "egress" {
    for_each = local.workspace["security_group"]["jenkins"]["outbound"]
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

