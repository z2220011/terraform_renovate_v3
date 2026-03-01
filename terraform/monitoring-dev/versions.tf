terraform {
  required_version = ">= 1.2.0"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.15.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-monitoring-dev"
    key    = "monitoring/dev/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
