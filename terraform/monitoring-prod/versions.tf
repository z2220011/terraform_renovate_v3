terraform {
  required_version = ">= 1.3.0"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.20.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-monitoring-prod"
    key    = "monitoring/prod/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
