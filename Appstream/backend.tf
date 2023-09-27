# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "coh-test-terraform-remote-state"
    key            = "terraform-module/coh-project/terraform.tfstate"
    region         = "us-east-1"
    profile        = "adm-tosin.ojo"
  }
}