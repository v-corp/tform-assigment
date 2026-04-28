variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "alb_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}
