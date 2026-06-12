variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for naming resources"
  default     = "aws-3tier"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}
variable "developer_ip" {
  description = "Developer IP for SSH access"
  default     = "0.0.0.0/0"
}
# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
# Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = "ami-07a00cf47dbbc844c"
  instance_type = "t3.micro"
  key_name      = "${var.project_name}-key"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app.id]
  }

  iam_instance_profile {
    name = "aws-3tier-ec2-role"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io awscli
    systemctl start docker
    systemctl enable docker
    export AWS_DEFAULT_REGION=ap-south-1
    ECR_TOKEN=$(aws ecr get-login-password --region ap-south-1)
    echo $ECR_TOKEN | docker login --username AWS --password-stdin 108209429292.dkr.ecr.ap-south-1.amazonaws.com
    docker pull 108209429292.dkr.ecr.ap-south-1.amazonaws.com/url-shortener:latest
    docker run -d -p 80:80 108209429292.dkr.ecr.ap-south-1.amazonaws.com/url-shortener:latest
  EOF
  )

  tags = {
    Name = "${var.project_name}-lt"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 3
  target_group_arns   = [aws_lb_target_group.app.arn]
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app"
    propagate_at_launch = true
  }
}

# Auto Scaling Policy
resource "aws_autoscaling_policy" "cpu" {
  name                   = "cpu-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}