# Application Load Balancer
resource "aws_lb" "web_lb" {
  name               = "${var.group_name}-${var.environment}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            = var.load_balancer_public_subnet_ids
  
  enable_deletion_protection = false
  
  tags = {
    Name = "${var.group_name}-${var.environment}-ALB"
  }
}

# Target Group for ASG instances
resource "aws_lb_target_group" "web_tg" {
  name     = "${var.group_name}-${var.environment}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  
  tags = {
    Name = "${var.group_name}-${var.environment}-TG"
  }
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
