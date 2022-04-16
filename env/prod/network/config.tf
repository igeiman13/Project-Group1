terraform {
  backend "s3" {
    bucket = "prod-group1-acsproject"
    key    = "prod-network/terraform.tfstate"
    region = "us-east-1"
  }
}
