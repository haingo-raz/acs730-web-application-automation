# Security group for public web servers
resource "aws_security_group" "webserver_sg" {
  name        = "${var.group_name}-${var.environment_name}-Webserver-SG"
  description = "Security group for public web servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.group_name}-${var.environment_name}-Webserver-SG"
  }
}

# Security group for private instances (WebServer5, VM6)
resource "aws_security_group" "private_sg" {
  name        = "${var.group_name}-${var.environment_name}-Private-SG"
  description = "Security group for private instances"
  vpc_id      = var.vpc_id

  # Allow SSH only from Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
    description     = "Allow SSH only from Bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.group_name}-${var.environment_name}-Private-SG"
  }
}

# Security group for load balancer
resource "aws_security_group" "lb_sg" {
  name        = "${var.group_name}-${var.environment_name}-LB-SG"
  description = "Security group for load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.group_name}-${var.environment_name}-LB-SG"
  }
}
