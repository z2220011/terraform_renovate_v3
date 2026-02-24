resource "aws_s3_bucket" "shared_artifacts" {
  bucket = "shared-artifacts-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "shared-artifacts"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "shared_artifacts" {
  bucket = aws_s3_bucket.shared_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "shared_artifacts" {
  bucket = aws_s3_bucket.shared_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.shared_artifacts.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "shared_artifacts" {
  bucket = aws_s3_bucket.shared_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "shared_artifacts" {
  bucket = aws_s3_bucket.shared_artifacts.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountAccess"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::111111111111:root",
            "arn:aws:iam::222222222222:root",
            "arn:aws:iam::333333333333:root"
          ]
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.shared_artifacts.arn,
          "${aws_s3_bucket.shared_artifacts.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_kms_key" "shared_artifacts" {
  description             = "KMS key for shared artifacts encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Cross-Account Usage"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::111111111111:root",
            "arn:aws:iam::222222222222:root",
            "arn:aws:iam::333333333333:root"
          ]
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "shared-artifacts-key"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_kms_alias" "shared_artifacts" {
  name          = "alias/shared-artifacts"
  target_key_id = aws_kms_key.shared_artifacts.key_id
}

resource "aws_s3_bucket" "shared_logs" {
  bucket = "shared-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "shared-logs"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "shared_logs" {
  bucket = aws_s3_bucket.shared_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "shared_logs" {
  bucket = aws_s3_bucket.shared_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "shared_logs" {
  bucket = aws_s3_bucket.shared_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "shared_logs" {
  bucket = aws_s3_bucket.shared_logs.id

  rule {
    id     = "archive-old-logs"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "shared-terraform-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "shared-terraform-state"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform_state.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "terraform_state" {
  description             = "KMS key for Terraform state encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = "shared-terraform-state-key"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_kms_alias" "terraform_state" {
  name          = "alias/shared-terraform-state"
  target_key_id = aws_kms_key.terraform_state.key_id
}

data "aws_caller_identity" "current" {}

resource "aws_ec2_transit_gateway" "main" {
  description = "Shared transit gateway for cross-account connectivity"

  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name        = "shared-transit-gateway"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_ec2_transit_gateway_route_table" "main" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name        = "shared-tgw-route-table"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}
