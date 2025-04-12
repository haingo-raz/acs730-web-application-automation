module "security_groups" {
  source      = "../../modules/security_group"
  vpc_id      = data.terraform_remote_state.aws_network.outputs.vpc_id
  group_name  = var.group_name
  environment_name = var.environment_name
}

module "aws_webservers" {
  source = "../../modules/aws_webservers"

  environment_name   = var.environment_name
  group_name         = var.group_name
  instance_type      = var.instance_type
  private_subnet_ids = data.terraform_remote_state.aws_network.outputs.private_subnet_ids
  public_subnet_ids  = data.terraform_remote_state.aws_network.outputs.public_subnet_ids
  webserver_sg_id    = module.security_groups.webserver_sg_id # From the security_group module
  private_sg_id      = module.security_groups.private_sg_id
  key_name           = var.key_name
  target_group_arn = module.load_balancer.target_group_arn
}

data "terraform_remote_state" "aws_network" {
  backend = "s3"
  config = {
    bucket = "acs730-final-nh"
    key    = "staging/network/terraform.tfstate"
    region = "us-east-1"
  }
}

module "load_balancer" {
  source             = "../../modules/load_balancer"
  environment        = var.environment_name
  group_name         = var.group_name
  lb_sg_id            = module.security_groups.lb_sg_id
  vpc_id             = data.terraform_remote_state.aws_network.outputs.vpc_id
  load_balancer_public_subnet_ids = data.terraform_remote_state.aws_network.outputs.public_subnet_ids
}