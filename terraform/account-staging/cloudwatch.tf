resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/application/staging"
  retention_in_days = 14

  tags = {
    Name        = "staging-application-logs"
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "alb" {
  name              = "/aws/alb/staging"
  retention_in_days = 14

  tags = {
    Name        = "staging-alb-logs"
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "staging-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    Environment = "staging"
  }

  tags = {
    Name        = "staging-cpu-alarm"
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_target_response_time" {
  alarm_name          = "staging-alb-target-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 2
  alarm_description   = "This metric monitors ALB target response time"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  tags = {
    Name        = "staging-alb-response-time-alarm"
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "staging-rds-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = {
    Name        = "staging-rds-cpu-alarm"
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic" "alerts" {
  name = "staging-alerts"

  tags = {
    Name        = "staging-alerts"
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "staging-team@example.com"
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "staging-overview"

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
