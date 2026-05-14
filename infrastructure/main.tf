# 1. Provider
provider "aws" {
  region = "eu-north-1" # Ստուգիր քո ռեգիոնը
}

# 2. VPC
resource "aws_vpc" "genesis_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Genesis-VPC" }
}

# 3. Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.genesis_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = { Name = "Genesis-Public-Subnet" }
}

# 4. Private Subnet 1
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.genesis_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1a"
  tags = { Name = "Genesis-Private-Subnet-1" }
}

# 5. Private Subnet 2 (HW19 New Requirement)
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.genesis_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-north-1b" # Պարտադիր տարբեր AZ
  tags = { Name = "Genesis-Private-Subnet-2" }
}

# 6. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.genesis_vpc.id
  tags   = { Name = "Genesis-IGW" }
}

# 7. Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.genesis_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "Genesis-Public-RT" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.genesis_vpc.id
  tags   = { Name = "Genesis-Private-RT" }
}

# 8. Route Table Associations
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# 9. DB Subnet Group (HW19 New Requirement)
resource "aws_db_subnet_group" "genesis_db_subnet_group" {
  name       = "genesis-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id]
  tags       = { Name = "Genesis-DB-Subnet-Group" }
}



# 1. Variables (Գաղտնաբառի համար)
variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

# 2. Security Group EC2-ի համար
resource "aws_security_group" "app_sg" {
  name        = "genesis-app-sg"
  vpc_id      = aws_vpc.genesis_vpc.id

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

# 3. Security Group RDS-ի համար (Միայն App-ից մուտք)
resource "aws_security_group" "db_sg" {
  name        = "genesis-db-sg"
  vpc_id      = aws_vpc.genesis_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id] # Խիստ կապ
  }
}

# 4. PostgreSQL RDS Instance
resource "aws_db_instance" "genesis_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15" # Կամ 16
  instance_class       = "db.t3.micro"
  db_name              = "genesisdb"
  username             = "postgres"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.genesis_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
  publicly_accessible  = false
}

# 5. EC2 Instance + User Data (Ավտոմատացում)
resource "aws_instance" "app_server" {
  ami           = "ami-0fe8bec493a81c7da" # Ubuntu 22.04 LTS eu-north-1-ում (Ստուգիր AMI-ն)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y git docker.io docker-compose
              sudo systemctl start docker
              sudo usermod -aG docker ubuntu

              cd /home/ubuntu
              git clone https://github.com/ErikNazaryan/AI-Help.git
              cd AI-Help

              # Ստեղծում ենք .env ֆայլը դինամիկ կերպով
              echo "DATABASE_URL=postgres://postgres:${var.db_password}@${aws_db_instance.genesis_db.endpoint}/genesisdb" > .env

              sudo docker-compose up -d
              EOF

  tags = { Name = "Genesis-App-Server" }
}


