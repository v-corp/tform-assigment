resource "aws_key_pair" "test_key" {
  key_name   = "test-key"
  public_key = file(pathexpand("~/.ssh/tf.pub"))
}

module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr= var.vpc_cidr
  azs= var.azs
  public_subnet_cidrs=var.public_subnet_cidrs
  private_subnet_cidrs=var.private_subnet_cidrs
}

module "alb" {
  source= "./modules/alb"
  project_name= var.project_name
  vpc_id= module.vpc.vpc_id
  public_subnet_ids= module.vpc.public_subnet_ids
}

module "ec2" {
  source = "./modules/ec2"
  project_name= var.project_name
  vpc_id= module.vpc.vpc_id
  private_subnet_ids= module.vpc.private_subnet_ids
  ami_id= var.ami_id
  instance_type= var.instance_type
  key_name= aws_key_pair.test_key.key_name
  desired_capacity= var.desired_capacity
  alb_security_group_id = module.alb.security_group_id
  target_group_arn = module.alb.target_group_arn
}