module "mysql_database" {
  source                 = "git::https://github.com/tothenew/terraform-aws-rds.git"
  name                   = local.service_name_prefix
  common_tags            = local.common_tags
  subnet_ids             = data.aws_subnets.database.ids
  vpc_id                 = data.aws_vpc.selected.id
  sg_allow_inbound_cidrs = concat([for s in data.aws_subnet.private : s.cidr_block], [for s in data.aws_subnet.app_tools : s.cidr_block])

  parameter_family   = local.workspace["rds"]["parameter_family"]
  engine             = local.workspace["rds"]["cluster_engine"]
  engine_version     = local.workspace["rds"]["cluster_engine_version"]
  availability_zones = [for s in data.aws_subnet.database : s.availability_zone]

  instance_class = local.workspace["rds"]["instance_type"]
  database_name  = local.workspace["rds"]["database_name"]

  preferred_backup_window = local.workspace["rds"]["preferred_backup_window"]
  maintenance_window      = local.workspace["rds"]["maintenance_window"]
}
