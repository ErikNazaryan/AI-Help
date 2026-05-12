resource "aws_s3_bucket" "terraform_state" {
  bucket = "erik-genesis-terraform-state" # Անունը պետք է լինի ունիկալ աշխարհում
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
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




