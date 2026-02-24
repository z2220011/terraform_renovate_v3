terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-shared"
    key    = "shared/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
