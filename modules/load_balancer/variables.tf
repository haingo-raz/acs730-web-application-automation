variable "group_name" {
  description = "Group name for resource naming"
  type        = string
}

variable "environment"{
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "lb_sg_id" {
  description = "ID of the load balancer security group"
  type        = string
}

variable "load_balancer_public_subnet_ids" {
  description = "The subnet IDs for the load balancer"
  type        = list(string)

}
