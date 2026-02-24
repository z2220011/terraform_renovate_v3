terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-prod"
    key    = "prod/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
