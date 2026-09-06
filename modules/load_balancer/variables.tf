variable "project" {
  description = "Project name prefix for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the load balancer will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "port" {
  description = "Port number for the ALB listener"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path for ALB health checks"
  type        = string
  default     = "/"
}

