resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/application/prod"
  retention_in_days = 30

  tags = {
    Name        = "prod-application-logs"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "alb" {
  name              = "/aws/alb/prod"
  retention_in_days = 30

  tags = {
    Name        = "prod-alb-logs"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "prod-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    Environment = "production"
  }

  tags = {
    Name        = "prod-cpu-alarm"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_target_response_time" {
  alarm_name          = "prod-alb-target-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "This metric monitors ALB target response time"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  tags = {
    Name        = "prod-alb-response-time-alarm"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "prod-rds-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = {
    Name        = "prod-rds-cpu-alarm"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic" "alerts" {
  name = "prod-alerts"

  tags = {
    Name        = "prod-alerts"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "ops-team@example.com"
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "prod-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = "ap-northeast-1"
          title  = "EC2 CPU Utilization"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", { stat = "Sum" }]
          ]
          period = 300
          stat   = "Sum"
          region = "ap-northeast-1"
          title  = "ALB Request Count"
        }
      }
    ]
  })
}
