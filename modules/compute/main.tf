# AMI Lookup (Amazon Linux 2)
data "aws_ssm_parameter" "amzn2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Launch Template
resource "aws_launch_template" "this" {
  name_prefix = "${var.project}-lt"

  image_id      = data.aws_ssm_parameter.amzn2.value
  instance_type = var.instance_type

  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "Hello! Welcome to my Auto-healing web tier!" > /var/www/html/index.html
EOF
  )

  network_interfaces {
    security_groups             = [var.ec2_sg_id] # IMPORTANT: from network module
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-instance"
    }
  }
}
#
# Auto Scaling Group
resource "aws_autoscaling_group" "this" {
  name             = "${var.project}-asg"
  max_size         = 3
  min_size         = 2
  desired_capacity = 2

  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 30

  # Automatically refresh instances when the Launch Template changes
  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 100
      auto_rollback          = true
    }

    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-instance"
    propagate_at_launch = true
  }
}

