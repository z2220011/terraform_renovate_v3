resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/application/dev"
  retention_in_days = 7

  tags = {
    Name        = "dev-application-logs"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "alb" {
  name              = "/aws/alb/dev"
  retention_in_days = 7

  tags = {
    Name        = "dev-alb-logs"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "dev-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    Environment = "development"
  }

  tags = {
    Name        = "dev-cpu-alarm"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_target_response_time" {
  alarm_name          = "dev-alb-target-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 3
  alarm_description   = "This metric monitors ALB target response time"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  tags = {
    Name        = "dev-alb-response-time-alarm"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "dev-rds-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = {
    Name        = "dev-rds-cpu-alarm"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic" "alerts" {
  name = "dev-alerts"

  tags = {
    Name        = "dev-alerts"
    Environment = "development"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "dev-team@example.com"
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "dev-overview"

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
