output "alb_dns_name" {
  value = module.load_balancer.alb_dns_name
}

output "asg_name" {
  value = module.compute.asg_name
}
