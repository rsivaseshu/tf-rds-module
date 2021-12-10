# Define the following local variables with the corresponding values.
locals {
  name          = "mysqlexample"
  instance_name = "MySqlDemo"
  # Provide proper Terraform syntax for your preferred SQL Engine
  engine = "mysql"
  # Must provide preexisting secret manager secret which contains the username and password values. 
  #  secret_name = "<secrets manager secret name>"
  region = "us-east-1" # default region

  # Must provide preexisting VPC ID and subnet IDs
  vpc_id     = "vpc-0dbc0b44a6583f34e"
  subnet_ids = ["subnet-045c1bad5ed3f462b", "subnet-032d469b7f0923f3f"]
  port       = 3306
  #  credentials = jsondecode(
  #  data.aws_secretsmanager_secret_version.secret.secret_string)

  # Must provide valid values for the following required tags. Enforced by validation and policy.
  tags = {
    Name    = "siva",
    Project = "test"
  }
}

################################################################################
# Supporting Resources
################################################################################

data "aws_vpc" "vpc" {
  id = local.vpc_id
}

resource "aws_security_group" "mysql-sg" {
  name        = local.name
  description = "Security Group for DB created by Golden RDS Module"
  vpc_id      = local.vpc_id

  # Add any SG related tags
  tags = merge(
    {
      "Name" = format("%s", local.name)
    },
    local.tags,
  )
}

# Allows traffic via default port based on SQL engine
# Traffic allowed from VPC CIDR blocks specified
# Define SG rules for the DB
resource "aws_security_group_rule" "mysql-sg-rules" {
  security_group_id = aws_security_group.mysql-sg.id # may need to add data.
  type              = "ingress"

  cidr_blocks = tolist([data.aws_vpc.vpc.cidr_block])
  description = "MySQL access from within VPC"

  from_port = local.port
  to_port   = local.port
  protocol  = "tcp"
}

################################################################################
# RDS Module
################################################################################

module "db" {
  source     = "git@github.com:rsivaseshu/tf-rds-module.git?ref=main"
  identifier = local.name
  name       = local.name

  vpc_id = local.vpc_id

  # Must provide preexisting KMS Key to encrypt and decrypt DB data

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = local.engine
  engine_version       = "8.0.20"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  instance_class       = "db.t3.large"

  # default storage class is iops, general purpose (gp2) is also supported.
  publicly_accessible   = true
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_encrypted     = false

  username      = "siva"
  password      = "sivaseshagirirao"
  port          = local.port
  database_port = local.port

  multi_az               = false # Must be set to true for test and prod environments
  subnet_ids             = local.subnet_ids
  vpc_security_group_ids = tolist([aws_security_group.mysql-sg.id]) # may need to add data.

  maintenance_window      = "" # ex. Mon:00:00-Mon:03:00
  backup_window           = "" # 03:00-06:00
  backup_retention_period = 0
  skip_final_snapshot     = false
  deletion_protection     = false

  # All engine specific cloudwatch log groups enabled
  enabled_cloudwatch_logs_exports = ["general"]

  create_monitoring_role = true
  monitoring_interval    = 60

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = local.tags

  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}