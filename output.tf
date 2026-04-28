output "security_group_id" {
  value = module.ec2.security_group_id
}

output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}