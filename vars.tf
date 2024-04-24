variable "name" {
  default = "rabbitmq"
}
variable "port_no" {
  default = "5672"
}
variable "env" {}
variable "kms_arn" {}
variable "tags" {}
variable "allow_db_cidr" {}
variable "subnets" {}
variable "vpc_id" {}
variable "instance_type" {}
variable "bastion_cidr" {}