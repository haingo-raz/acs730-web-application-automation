variable "group_name" {
  type        = string
  description = "nh"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "environment_name" {
  type        = string
  description = "Name of the environment (e.g., dev, staging, prod)"
}

variable "create_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT Gateway"
  default     = false
}

variable "create_internet_gateway" {
  type        = bool
  description = "Whether to create an Internet Gateway"
  default     = true
}
