terraform {
  backend "s3" {
    bucket = "dev-group1-acsproject"
    key    = "dev-network/terraform.tfstate"
    region = "us-east-1"
  }
}
