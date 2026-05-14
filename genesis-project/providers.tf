terraform {
  backend "s3" {
    bucket         = "genesis-terraform-state-bucket"
    key            = "genesis/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock"
  }
}

