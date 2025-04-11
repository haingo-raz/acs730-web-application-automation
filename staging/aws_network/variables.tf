variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.5.0/24", "10.1.6.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "environment_name" {
  type    = string
  default = "staging"
}

variable "create_nat_gateway" {
  type    = bool
  default = true
}

variable "create_internet_gateway" {
  type    = bool
  default = true
}

variable "group_name" {
  type        = string
  description = "nh"
  default = "nh"
}