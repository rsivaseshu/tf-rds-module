variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the DB parameter group"
  type        = string
  default     = ""
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = true
}

variable "description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = ""
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of DB parameters to apply. Note that parameters may differ from a DB family to another"
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
