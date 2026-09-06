variable "project" {
  description = "Project name prefix for resource naming"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "alb_sg_id" {
  description = "Security group ID of the ALB, passed from load_balancer module"
  type        = string
}

