#security groups variables
variable "project_name" {}
variable "environment" {}
variable "costcenter" {}
variable "createdby" {}
variable "data_sensitivity" {}
variable "vpc_id" {}
variable "ingress_cidr" {
    type = list(string) 
}

