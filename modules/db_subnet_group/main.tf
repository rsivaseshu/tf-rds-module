locals {
  name        = var.use_name_prefix ? null : var.name
  name_prefix = var.use_name_prefix ? "${var.name}-" : null

  description = coalesce(var.description, format("%s subnet group", var.name))
}

resource "aws_db_subnet_group" "this" {
  count = var.create ? 1 : 0

  name        = local.name
  name_prefix = local.name_prefix
  description = local.description
  subnet_ids  = var.subnet_ids

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )
}

resource "aws_security_group" "this" {
  count = var.create ? 1 : 0

  name        = local.name
  description = "Allow inbound traffic from the security groups"
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count = var.create ? length(var.security_group_ids) : 0

  description              = "Allow inbound traffic from existing Security Groups"
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  source_security_group_id = var.security_group_ids[count.index]
  security_group_id        = join("", aws_security_group.this.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count = var.create && length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = var.database_port
  to_port           = var.database_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.this.*.id)
}

resource "aws_security_group_rule" "egress" {
  count             = var.create ? 1 : 0
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.this.*.id)
}
