provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "amazon-connect-bootcamp2020"
    region = "ap-northeast-1"
    key    = "terraform"
  }

  required_version = ">= 0.13.5"
}
