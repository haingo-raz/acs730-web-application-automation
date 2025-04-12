variable "environment_name" {
  type    = string
  default = "staging"
}

variable "group_name" {
  type    = string
  default = "nh"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type = string
  default = "nh"
}