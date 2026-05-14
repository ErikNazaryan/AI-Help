#  Golden AMI-ն (Phase 4)
data "aws_ami" "golden" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    
    values = ["genesis-golden-hw24-*"] 
  }
}

# 1. Security Group for Instances
resource "aws_security_group" "instance_sg" {
  name   = "instance-sg"
  vpc_id = var.vpc_id

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

# 2. IAM Role, Policy and Instance Profile for SSM Access
resource "aws_iam_role" "instance_role" {
  name = "genesis-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ssm_policy" {
  name = "ssm-read-policy"
  role = aws_iam_role.instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter"]
        Resource = "arn:aws:ssm:eu-north-1:*:parameter/project-genesis/*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "genesis-instance-profile"
  role = aws_iam_role.instance_role.name
}

# 3. Launch Template with DYNAMIC Golden AMI lookup
resource "aws_launch_template" "lt" {
  name_prefix   = "genesis-golden-"
  
  # ՀԻՄԱ ԱՎՏՈՄԱՏ Է (Phase 4)
  image_id      = data.aws_ami.golden.id
  
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.instance_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Fetch secrets from SSM Parameter Store
    DB_USER=$(aws ssm get-parameter --name "/project-genesis/db-username" --query Parameter.Value --output text --region eu-north-1)
    DB_PASS=$(aws ssm get-parameter --name "/project-genesis/db-password" --with-decryption --query Parameter.Value --output text --region eu-north-1)

    # Clone the latest code
    cd /home/ec2-user
    rm -rf app
    git clone -b hw20 https://github.com/ErikNazaryan/AI-Help app
    cd app

    # Build and run with credentials injected as environment variables
    sudo docker build -t genesis-app .
    sudo docker run -d -p 80:5000 \
      -e DB_USER=$DB_USER \
      -e DB_PASS=$DB_PASS \
      genesis-app
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

# 4. Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = var.subnet_ids
  min_size            = 1
  max_size            = 2
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "genesis-app-instance"
    propagate_at_launch = true
  }
}