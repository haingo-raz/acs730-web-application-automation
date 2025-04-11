output "vpc_id" {
  value       = module.aws_network.vpc_id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = module.aws_network.public_subnet_ids
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = module.aws_network.private_subnet_ids
  description = "The IDs of the private subnets"
}