resource "aws_security_group" "sg" {
  name   = "${var.project_name}-sg"
  vpc_id = var.vpc_id
}
resource "aws_vpc_security_group_ingress_rule" "http_from_alb" {
  security_group_id= aws_security_group.sg.id
  referenced_security_group_id= var.alb_security_group_id
  from_port= 80
  to_port= 80
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4= "0.0.0.0/0"
  ip_protocol= "-1"
}
resource "aws_instance" "ec2" {
  count = var.desired_capacity

  tags = {
    Name = "${var.project_name}-ec2-${count.index + 1}"
  }
  ami = var.ami_id
  instance_type= var.instance_type
  associate_public_ip_address = false

  
  
  
  
  
  
  
  
  key_name= var.key_name
  vpc_security_group_ids  = [aws_security_group.sg.id]
  subnet_id     = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  user_data_replace_on_change = true
  user_data                   = <<-EOF
              #!/bin/bash
  apt-get update -y
apt-get install -y nginx
systemctl enable nginx
echo "hello from ${var.project_name} $(hostname)" > /usr/share/nginx/html/index.html
systemctl start nginx
              EOF

  root_block_device {
    delete_on_termination = true
    volume_size=12
    # volume_type="gp3"
  }
}

resource "aws_lb_target_group_attachment" "ec2" {
  count = var.desired_capacity
target_group_arn = var.target_group_arn
  target_id= aws_instance.ec2[count.index].id
  port= 80
}

