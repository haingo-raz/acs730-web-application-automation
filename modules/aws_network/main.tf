resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.group_name}-${var.environment_name}-vpc"
    Environment = var.environment_name
  }
}

resource "aws_subnet" "public" {
  count                  = length(var.public_subnet_cidrs)
  vpc_id                 = aws_vpc.main.id
  cidr_block             = element(var.public_subnet_cidrs, count.index)
  availability_zone      = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.group_name}-${var.environment_name}-public-subnet${count.index + 1}"
    Environment = var.environment_name
    Type        = "Public"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.group_name}-${var.environment_name}-private-subnet${count.index + 1}"
    Environment = var.environment_name
    Type        = "Private"
  }
}

# Internet Gateway for Public Subnets
resource "aws_internet_gateway" "gw" {
  count   = var.create_internet_gateway ? 1 : 0
  vpc_id   = aws_vpc.main.id

  tags = {
    Name        = "${var.group_name}-${var.environment_name}-igw"
    Environment = var.environment_name
    Type        = "InternetGateway"
  }
}

# NAT Gateway for Private Subnets (Webserver 5)
resource "aws_nat_gateway" "nat" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "${var.group_name}-${var.environment_name}-nat-gateway"
    Environment = var.environment_name
    Type        = "NATGateway"
  }

}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count      = var.create_nat_gateway ? 1 : 0

  tags = {
    Name        = "${var.group_name}-${var.environment_name}-nat-eip"
  }
}

# Public Route Table for Internet Gateway association
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.create_internet_gateway ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw[0].id
    }
  }

  tags = {
    Name = "${var.group_name}-${var.environment_name}-rt-igw"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table for NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  dynamic "route" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[0].id
    }
  }

  tags = {
    Name = "${var.group_name}-${var.environment_name}-rt-ngw"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}