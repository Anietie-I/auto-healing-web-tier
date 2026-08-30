variable "project" {}
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "sg_id" {}
variable "port" {
  default = 80
}
variable "health_check_path" {
  default = "/"
}
