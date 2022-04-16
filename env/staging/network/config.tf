terraform {
  backend "s3" {
    bucket = "staging1-group1-acsproject"
    key    = "staging-network/terraform.tfstate"
    region = "us-east-1"
  }
}
