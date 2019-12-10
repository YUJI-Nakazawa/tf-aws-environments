data "aws_caller_identity" "current" {}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "jiyu-root"
}

# NOTE: ここのパラメータはvariablesが利用できないため、ベタに書く必要がある点に注意
terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    region  = "ap-northeast-1"
    profile = "jiyu-root"
    bucket  = "jiyu-root-tfstate-bucket"
    key     = "terraform.tfstate"
    encrypt = true
  }
}
