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
  subnet_id              = var.public_subnet_ids[1]
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