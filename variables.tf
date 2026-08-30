variable "project" {
  default = "auto-healing-web-tier"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (example)
}

variable "instance_type" {
  default = "t3.micro"
}

variable "port" {
  default = 80
}

variable "health_check_path" {
  default = "/"
}
