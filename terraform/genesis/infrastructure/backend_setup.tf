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
