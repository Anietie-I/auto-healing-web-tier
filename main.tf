# Providers
provider "aws" {
  region = var.region
}

# Network Module
module "network" {
  source     = "./modules/network"
  project    = var.project
  cidr_block = var.cidr_block

  # ALB SG comes from load_balancer module
  alb_sg_id = module.load_balancer.alb_sg_id
}


# Load Balancer Module
module "load_balancer" {
  source            = "./modules/load_balancer"
  project           = var.project
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  port              = var.port
  health_check_path = var.health_check_path
}

# Compute Module
module "compute" {
  source            = "./modules/compute"
  project           = var.project
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  instance_type     = var.instance_type

  # From load_balancer module
  target_group_arn = module.load_balancer.target_group_arn
  alb_sg_id        = module.load_balancer.alb_sg_id

  # From network module
  ec2_sg_id = module.network.ec2_sg_id
}
