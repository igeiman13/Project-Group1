terraform {
  backend "s3" {
    bucket = "prod-group1-acsproject"
    key    = "prod-webserver/terraform.tfstate"
    region = "us-east-1"
  }
}
