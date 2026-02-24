terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-dev"
    key    = "dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
