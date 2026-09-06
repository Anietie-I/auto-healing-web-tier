variable "project" {
  type    = string
  default = "auto-healing-web-tier"
}

variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}


