provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "remote" {
    organization = "wwalpha"

    workspaces {
      name = "amazon-connect-bootcamp"
    }
  }

  required_version = ">= 0.13.5"
}
