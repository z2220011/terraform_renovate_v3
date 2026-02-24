resource "aws_iam_role" "cross_account_access" {
  name = "shared-cross-account-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::111111111111:root",
            "arn:aws:iam::222222222222:root",
            "arn:aws:iam::333333333333:root"
          ]
        }
      }
    ]
  })

  tags = {
    Name        = "shared-cross-account-access-role"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_policy" "cross_account_policy" {
  name        = "shared-cross-account-policy"
  description = "Policy for cross-account access to shared resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.shared_artifacts.arn}",
          "${aws_s3_bucket.shared_artifacts.arn}/*"
        ]
      }
    ]
  })

  tags = {
    Name        = "shared-cross-account-policy"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "cross_account_attach" {
  role       = aws_iam_role.cross_account_access.name
  policy_arn = aws_iam_policy.cross_account_policy.arn
}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "shared-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "shared-vpc-flow-logs-role"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_policy" "vpc_flow_logs_policy" {
  name        = "shared-vpc-flow-logs-policy"
  description = "Policy for VPC flow logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "shared-vpc-flow-logs-policy"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs_attach" {
  role       = aws_iam_role.vpc_flow_logs.name
  policy_arn = aws_iam_policy.vpc_flow_logs_policy.arn
}

resource "aws_iam_role" "transit_gateway_role" {
  name = "shared-transit-gateway-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "shared-transit-gateway-role"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_policy" "transit_gateway_policy" {
  name        = "shared-transit-gateway-policy"
  description = "Policy for transit gateway operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeTransitGateways",
          "ec2:DescribeTransitGatewayAttachments",
          "ec2:DescribeTransitGatewayRouteTables"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "shared-transit-gateway-policy"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "transit_gateway_attach" {
  role       = aws_iam_role.transit_gateway_role.name
  policy_arn = aws_iam_policy.transit_gateway_policy.arn
}

resource "aws_iam_role" "backup_role" {
  name = "shared-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "shared-backup-role"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "backup_policy" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "backup_restore_policy" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}
