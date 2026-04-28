resource "aws_security_group" "alb" {
  name   = "${var.project_name}-alb-sg"
  vpc_id = var.vpc_id
}
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4= "0.0.0.0/0"
  from_port= 80
  to_port=80
  ip_protocol="tcp"
}
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4="0.0.0.0/0"
  ip_protocol= "-1"
}
resource "aws_lb" "this" {
  name="${var.project_name}-alb"
        load_balancer_type="application"
        security_groups=[aws_security_group.alb.id]
  subnets=var.public_subnet_ids
}
resource "aws_lb_target_group" "this" {
  name= "${var.project_name}-tg"
  port= 80
  protocol= "HTTP"
  vpc_id= var.vpc_id
health_check {
    path= "/"
    protocol= "HTTP"
    matcher= "200-399"
    healthy_threshold= 2
    unhealthy_threshold=2
    interval= 30
    timeout= 5
}
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port= 80
  protocol= "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
}
}
