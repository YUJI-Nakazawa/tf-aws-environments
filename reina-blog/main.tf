# main provider
provider "aws" {
  region  = "ap-northeast-1"
  profile = "reina-blog"
}

# acm provider
# ACM 証明書を CloudFront ディストリビューションに割り当てるにはバージニア北部(us-east-1)に証明書をリクエストする必要がある
provider "aws" {
  region  = "us-east-1"
  profile = "reina-blog"
  alias   = "acm_provider"
}

# ses provider
provider "aws" {
  region  = "us-west-2"
  profile = "reina-blog"
  alias   = "ses_provider"
}

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    region  = "ap-northeast-1"
    profile = "jiyu-root"
    bucket  = "reina-blog-tfstate-bucket"
    key     = "terraform.tfstate"
    encrypt = true
  }
}
