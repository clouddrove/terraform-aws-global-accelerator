variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'"
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-globle-accelerator"
  description = "Terraform current module repo"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Indicates that the accelerator is enabled. Valid values: `true`, `false`"

}

variable "ip_address_type" {
  type        = string
  default     = "IPV4"
  description = "Type of IP address"

}

variable "flow_logs_enabled" {
  type        = bool
  default     = false
  description = "Indicates that flow logs are enabled. Valid values: `true`, `false`"
}

variable "flow_logs_s3_prefix" {
  type        = string
  default     = null
  description = "The prefix for the location where Amazon S3 bucket will store the flow logs. Required if `flow_logs_enabled` is `true`"
}

variable "flow_logs_s3_bucket" {
  type        = string
  default     = null
  description = "Flow logs S3 bucket name. Required if `flow_logs_enabled` is `true`"
}

variable "listeners" {
  type        = any
  description = "Mapping of listener that defintions to create"
}

variable "resources_enabled" {
  type        = bool
  default     = true
  description = "Controls if resources should be created. This will affects to all the resources"
}

variable "listeners_enabled" {
  type        = bool
  default     = true
  description = "Controls if listeners should be created This will affects to only for listeners"
}

