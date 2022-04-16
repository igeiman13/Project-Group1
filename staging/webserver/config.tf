terraform {
  backend "s3" {
    bucket = "staging-group1-acsproject"
    key    = "staging-webserver/terraform.tfstate"
    region = "us-east-1"
  }
}
