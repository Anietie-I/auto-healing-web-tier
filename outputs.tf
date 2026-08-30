output "alb_dns_name" {
  value = module.load_balancer.alb_dns_name
}

output "asg_name" {
  value = module.compute.asg_name
}
output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "alb_sg_id" {
  value = module.network.alb_sg_id
}
output "target_group_arn" {
  value = module.load_balancer.target_group_arn
}
