variable "group_name" {
  description = "Group name for resource naming"
  type        = string
}

variable "environment_name" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
