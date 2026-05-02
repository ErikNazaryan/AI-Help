# 1. Provider
provider "aws" {
  region = "eu-north-1"
}

# 2. VPC & Networking
resource "aws_vpc" "genesis_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Genesis-VPC" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.genesis_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = { Name = "Genesis-Public-Subnet" }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.genesis_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
  tags = { Name = "Genesis-Public-Subnet-2" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.genesis_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1a"
  tags = { Name = "Genesis-Private-Subnet-1" }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.genesis_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-north-1b"
  tags = { Name = "Genesis-Private-Subnet-2" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.genesis_vpc.id
  tags = { Name = "Genesis-IGW" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.genesis_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "Genesis-Public-RT" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 3. Security Groups
resource "aws_security_group" "app_sg" {
  name   = "genesis-app-sg"
  vpc_id = aws_vpc.genesis_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name   = "genesis-db-sg"
  vpc_id = aws_vpc.genesis_vpc.id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
}

# 4. Database 
resource "aws_db_subnet_group" "genesis_db_subnet_group" {
  name       = "genesis-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id]
  tags       = { Name = "Genesis-DB-Subnet-Group" }
}

resource "aws_db_instance" "genesis_db" {
  allocated_storage      = 20
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  db_name                = "genesisdb"
  username               = "postgres"
  password               = var.db_password
  
  
  db_subnet_group_name   = aws_db_subnet_group.genesis_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  skip_final_snapshot    = true
  publicly_accessible    = false
}

# 5. Load Balancer Layer
resource "aws_security_group" "alb_sg" {
  name   = "genesis-alb-sg"
  vpc_id = aws_vpc.genesis_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "genesis_alb" {
  name               = "genesis-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]
}

resource "aws_lb_target_group" "genesis_tg" {
  name     = "genesis-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.genesis_vpc.id
  health_check { path = "/" }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.genesis_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.genesis_tg.arn
  }
}

# 6. Auto Scaling Layer
resource "aws_launch_template" "app_lt" {
  name_prefix   = "genesis-lt"
  image_id      = "ami-0fe8bec493a81c7da"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

user_data = base64encode(<<-EOF
#!/bin/bash
set -e
apt-get update -y
apt-get install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
git clone https://github.com/ErikNazaryan/AI-Help.git /home/ubuntu/AI-Help
echo "DATABASE_URL=postgres://postgres:${var.db_password}@${aws_db_instance.genesis_db.endpoint}/genesis" > /home/ubuntu/AI-Help/.env
cd /home/ubuntu/AI-Help
docker-compose up -d
EOF
)
}

resource "aws_autoscaling_group" "genesis_asg" {
  vpc_zone_identifier = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.genesis_tg.arn]
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
}
