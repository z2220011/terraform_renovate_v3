resource "aws_s3_bucket" "app_data" {
  bucket = "dev-app-data-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "dev-app-data"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  rule {
    id     = "delete-old-objects"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "dev-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "dev-logs"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket" "backups" {
  bucket = "dev-backups-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "dev-backups"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "backups" {
  bucket = aws_s3_bucket.backups.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.backups.arn
    }
  }
}

resource "aws_kms_key" "backups" {
  description             = "KMS key for backup encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = false

  tags = {
    Name        = "dev-backups-key"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_kms_alias" "backups" {
  name          = "alias/dev-backups"
  target_key_id = aws_kms_key.backups.key_id
}

data "aws_caller_identity" "current" {}
