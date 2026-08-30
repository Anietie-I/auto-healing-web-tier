data "aws_ssm_parameter" "amzn2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_security_group" "compute_sg" {
  name        = "${var.project}-compute-sg"
  description = "Compute SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ALB to reach EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-lt"

  image_id      = data.aws_ssm_parameter.amzn2.value
  instance_type = var.instance_type

  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "Hello from your auto-healing web tier!" > /var/www/html/index.html
EOF
  )

  network_interfaces {
    security_groups             = [aws_security_group.compute_sg.id]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-instance"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.project}-asg"
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2
  vpc_zone_identifier       = var.public_subnet_ids
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 30

  tag {
    key                 = "Name"
    value               = "${var.project}-instance"
    propagate_at_launch = true
  }
}

