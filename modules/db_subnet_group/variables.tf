variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = ""
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = true
}

variable "description" {
  description = "The description of the DB subnet group"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID the DB instance will be created in"
  type        = string
}

variable "security_group_ids" {
  description = "The IDs of the security groups from which to allow `ingress` traffic to the DB instance"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "The whitelisted CIDRs which to allow `ingress` traffic to the DB instance"
  type        = list(string)
  default     = []
}

variable "database_port" {
  description = "Database port (_e.g._ `3306` for `MySQL`). Used in the DB Security Group to allow access to the DB instance from the provided `security_group_ids`"
  type        = number
}