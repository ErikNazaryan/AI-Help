resource "aws_security_group" "lb_sg" {
  name   = "AIhelpsg"
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

resource "aws_lb" "genesis_alb" {
  name               = "genesis-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.lb_sg.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "genesis-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.genesis_alb.arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}