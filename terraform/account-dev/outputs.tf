output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.main.arn
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "ec2_instance_role_arn" {
  description = "ARN of the EC2 instance IAM role"
  value       = aws_iam_role.ec2_instance_role.arn
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2.name
}

output "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_execution.arn
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for application data"
  value       = aws_s3_bucket.app_data.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket for application data"
  value       = aws_s3_bucket.app_data.arn
}

output "cloudwatch_log_group_application" {
  description = "Name of the CloudWatch log group for applications"
  value       = aws_cloudwatch_log_group.application.name
}

output "sns_topic_alerts_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "route53_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "route53_name_servers" {
  description = "Name servers for the Route53 zone"
  value       = aws_route53_zone.main.name_servers
}
