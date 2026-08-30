variable "project" {}
variable "ami_id" {}
variable "instance_type" {}
variable "sg_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "target_group_arn" {}
