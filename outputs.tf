output "alb_dns_name" {
  value = module.load_balancer.alb_dns_name
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "target_group_arn" {
  value = module.load_balancer.target_group_arn
}

