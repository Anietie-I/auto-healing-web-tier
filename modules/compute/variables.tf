variable "project" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ec2_sg_id" {
  type = string
}

