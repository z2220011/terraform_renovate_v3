output "vpc_id" {
  description = "The ID of the shared VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the shared VPC"
  value       = aws_vpc.main.cidr_block
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "shared_alb_dns_name" {
  description = "The DNS name of the shared services load balancer"
  value       = aws_lb.shared.dns_name
}

output "shared_alb_arn" {
  description = "The ARN of the shared services load balancer"
  value       = aws_lb.shared.arn
}

output "cross_account_role_arn" {
  description = "ARN of the cross-account access role"
  value       = aws_iam_role.cross_account_access.arn
}

output "transit_gateway_id" {
  description = "ID of the transit gateway"
  value       = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_route_table_id" {
  description = "ID of the transit gateway route table"
  value       = aws_ec2_transit_gateway_route_table.main.id
}

output "shared_artifacts_bucket" {
  description = "Name of the shared artifacts S3 bucket"
  value       = aws_s3_bucket.shared_artifacts.id
}

output "shared_artifacts_bucket_arn" {
  description = "ARN of the shared artifacts S3 bucket"
  value       = aws_s3_bucket.shared_artifacts.arn
}

output "shared_logs_bucket" {
  description = "Name of the shared logs S3 bucket"
  value       = aws_s3_bucket.shared_logs.id
}

output "vpc_flow_logs_role_arn" {
  description = "ARN of the VPC flow logs IAM role"
  value       = aws_iam_role.vpc_flow_logs.arn
}

output "backup_role_arn" {
  description = "ARN of the backup IAM role"
  value       = aws_iam_role.backup_role.arn
}

output "route53_private_zone_id" {
  description = "ID of the private Route53 hosted zone"
  value       = aws_route53_zone.private.zone_id
}

output "sns_topic_alerts_arn" {
  description = "ARN of the SNS topic for shared services alerts"
  value       = aws_sns_topic.alerts.arn
}
