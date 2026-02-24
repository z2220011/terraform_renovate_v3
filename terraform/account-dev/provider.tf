provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = "development"
      ManagedBy   = "Terraform"
      Account     = "dev"
    }
  }
}
