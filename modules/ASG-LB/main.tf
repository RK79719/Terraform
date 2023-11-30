# LB creation

resource "aws_lb" "example_lb" {
  name               = "nginx-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.public_subnets

}

# LB_Target_group creation

resource "aws_lb_target_group" "example_target_group" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id # Replace with your VPC ID
}

# Attach EC2 instances to the target group

resource "aws_lb_target_group_attachment" "example_attachment" {
  target_group_arn = aws_lb_target_group.example_target_group.arn
  target_id        = var.instance_id
}

# LB_Listener creation and attach target group

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.example_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_target_group.arn
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}

# Template Creation from ami

resource "aws_launch_template" "example_launch_template" {
  name_prefix            = "nginx-template"
  image_id               = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.sg_id]
  key_name               = "teju-key"


  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "nginx-template"
    }
  }
}

# AUtoScalingGroup Creation

resource "aws_autoscaling_group" "example_asg" {
  name                      = "example-asg"
  vpc_zone_identifier       = var.public_subnets
  min_size                  = 2
  max_size                  = 6
  desired_capacity          = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300
  //load_balancers = [aws_lb.example_lb.id]
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances",
  ]
  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.example_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "nginx-asg"
    propagate_at_launch = true
  }
}

# Attach autoscaling-group with target-group

resource "aws_autoscaling_attachment" "example_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.example_asg.name
  lb_target_group_arn    = aws_lb_target_group.example_target_group.arn
}

# Autoscaling_Policy & cloud watch metrics monitor creation for scale out scenario

resource "aws_autoscaling_policy" "policy_scale_out" {
  name                   = "example-policy-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.example_asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_up" {
  alarm_name          = "cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  period              = "120"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.example_asg.name
  }
  alarm_description = "This metric monitors EC2 instances CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.policy_scale_out.arn]


}


# Autoscaling_Policy & cloud watch metrics monitor creation for scale in scenario

resource "aws_autoscaling_policy" "policy_scale_in" {
  name                   = "example-policy-in"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.example_asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_down" {
  alarm_name          = "cpu_alarm_down"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  period              = "120"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.example_asg.name
  }
  alarm_description = "This metric monitors EC2 instances CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.policy_scale_in.arn]


}