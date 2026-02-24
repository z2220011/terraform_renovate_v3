resource "aws_s3_bucket" "logs" {
  bucket = "shared-centralized-logs-bucket"

  tags = {
    Name    = "Centralized Logs"
    Purpose = "Logging"
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "log-expiration"
    status = "Enabled"

    expiration {
      days = 90
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_kms_key" "shared" {
  description             = "Shared KMS key for encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name = "shared-kms-key"
  }
}

resource "aws_kms_alias" "shared" {
  name          = "alias/shared-encryption"
  target_key_id = aws_kms_key.shared.key_id
}
