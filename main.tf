# Root module for auto-healing web tier

# Create network layer
module "network" {
  source = "./modules/network"
  project = var.project
  cidr_block = var.vpc_cidr_block
}

# Create load balancer layer
module "load_balancer" {
  source             = "./modules/loadbalancer"
  project            = var.project
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  sg_id              = module.network.alb_sg_id
  port               = var.port
  health_check_path  = var.health_check_path
}

# Create compute layer
module "compute" {
  source            = "./modules/compute"
  project           = var.project
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  sg_name           = module.network.ec2_sg_name
  subnet_ids        = module.network.public_subnet_ids
  target_group_arn  = module.load_balancer.target_group_arn
}
