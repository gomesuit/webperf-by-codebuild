terraform {
  backend "s3" {
    key     = "webperf-by-codebuild/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = "true"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 1.41.0"
}
