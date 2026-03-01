terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-staging"
    key    = "staging/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
