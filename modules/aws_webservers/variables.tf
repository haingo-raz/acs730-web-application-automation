variable "group_name" {
  description = "Group name for resource naming"
  type        = string
}

variable "environment_name" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key name for instances"
  type        = string
}

variable "webserver_sg_id" {
  description = "Security group ID for public webservers"
  type        = string
}

variable "private_sg_id" {
  description = "Security group ID for private instances"
  type        = string
}

variable "public_subnet_ids" {
  description = "Map of public subnet IDs"
}

variable "private_subnet_ids" {
  description = "Map of private subnet IDs"
}
