resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.project}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from your auto-healing web tier!</h1>" > /var/www/html/index.html
EOF
  )

  security_group_names = [var.sg_name]
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.project}-asg"
  desired_capacity           = 2
  min_size                   = 2
  max_size                   = 3
  vpc_zone_identifier        = var.subnet_ids
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
  target_group_arns          = [var.target_group_arn]
  health_check_type          = "EC2"
  health_check_grace_period  = 300
}
