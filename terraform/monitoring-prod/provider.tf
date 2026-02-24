provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.newrelic_api_key
  region     = "US"
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = "production"
      ManagedBy   = "Terraform"
      Account     = "monitoring-prod"
    }
  }
}
