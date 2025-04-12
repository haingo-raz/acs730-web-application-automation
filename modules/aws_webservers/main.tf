# Key pair
resource "aws_key_pair" "web_key" {
  key_name   = "${var.key_name}"
  public_key = file("${var.key_name}.pub")
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# WebServer2/Bastion
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.web_key.key_name
  subnet_id              = var.public_subnet_ids[1]  # Bastion is public subnet 2
  vpc_security_group_ids = [var.webserver_sg_id]
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from ${var.group_name} ${var.environment_name} Bastion/WebServer2</h1>" > /var/www/html/index.html
  EOF
  
  tags = {
    Name = "${var.group_name}-${var.environment_name}-Bastion-WebServer2"
  }
}

# WebServer4 in public subnet 4 (AZ 1d)
resource "aws_instance" "webserver4" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.public_subnet_ids[3] # Public subnet 4
  vpc_security_group_ids = [var.webserver_sg_id]
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from ${var.group_name} ${var.environment_name} WebServer4</h1>" > /var/www/html/index.html
  EOF
  
  tags = {
    Name = "${var.group_name}-${var.environment_name}-WebServer4"
  }
}

# WebServer5
resource "aws_instance" "webserver5" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_ids[0] # WebServer5 in private subnet 1
  vpc_security_group_ids = [var.private_sg_id]
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from ${var.group_name} ${var.environment_name} WebServer5</h1>" > /var/www/html/index.html
  EOF
  
  tags = {
    Name = "${var.group_name}-${var.environment_name}-WebServer5"
  }
}

# VM6 in private subnet 2 (AZ 1b)
resource "aws_instance" "vm6" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_ids[1] # VM6 in private subnet 2
  vpc_security_group_ids = [var.private_sg_id]
  
  tags = {
    Name = "${var.group_name}-${var.environment_name}-VM6"
  }
}

##################################################################################################################################3

# Launch template for auto scaling group (WebServer1 and WebServer3)
resource "aws_launch_template" "asg_launch_template" {
  name_prefix   = "${var.group_name}-${var.environment_name}-WebLT-"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.webserver_sg_id]
  }
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from ${var.group_name} ${var.environment_name} Auto Scaling Group</h1>" > /var/www/html/index.html
  EOF
  )
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.group_name}-${var.environment_name}-ASG-Instance"
    }
  }
}

# Auto Scaling Group for WebServer1 and WebServer3
resource "aws_autoscaling_group" "web_asg" {
  name                = "${var.group_name}-${var.environment_name}-ASG"
  vpc_zone_identifier = [var.public_subnet_ids["0"], var.public_subnet_ids["2"]]
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  
  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }
  
  target_group_arns = [var.target_group_arn]
  
  tag {
    key                 = "Name"
    value               = "${var.group_name}-${var.environment_name}-ASG-Instance"
    propagate_at_launch = true
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Auto scaling policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.group_name}-${var.environment_name}-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.group_name}-${var.environment_name}-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

# CloudWatch alarms to trigger scaling
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.group_name}-${var.environment_name}-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Scale up if CPU > 70% for 4 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.group_name}-${var.environment_name}-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Scale down if CPU < 30% for 4 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}
