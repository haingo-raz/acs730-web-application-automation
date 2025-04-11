module "aws_network" {
  source = "../../modules/aws_network"

  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  azs                    = var.azs
  environment_name       = var.environment_name
  create_nat_gateway     = var.create_nat_gateway
  create_internet_gateway = var.create_internet_gateway
  group_name               = var.group_name
}
