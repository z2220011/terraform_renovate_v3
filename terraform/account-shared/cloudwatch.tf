resource "aws_cloudwatch_log_group" "shared_services" {
  name              = "/aws/shared-services"
  retention_in_days = 90

  tags = {
    Name        = "shared-services-logs"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "alb" {
  name              = "/aws/alb/shared"
  retention_in_days = 90

  tags = {
    Name        = "shared-alb-logs"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/shared-flow-logs"
  retention_in_days = 30

  tags = {
    Name        = "shared-vpc-flow-logs"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpn_tunnel_state" {
  alarm_name          = "shared-vpn-tunnel-down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TunnelState"
  namespace           = "AWS/VPN"
  period              = 300
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "VPN tunnel is down"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = {
    Name        = "shared-vpn-tunnel-alarm"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "transit_gateway_bytes" {
  alarm_name          = "shared-transit-gateway-high-traffic"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "BytesOut"
  namespace           = "AWS/TransitGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 1000000000
  alarm_description   = "High traffic through transit gateway"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = {
    Name        = "shared-tgw-traffic-alarm"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_metric_alarm" "directory_service_cpu" {
  alarm_name          = "shared-directory-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/DirectoryService"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Directory service CPU is high"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = {
    Name        = "shared-directory-cpu-alarm"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic" "alerts" {
  name = "shared-services-alerts"

  tags = {
    Name        = "shared-services-alerts"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "shared-services-team@example.com"
}

resource "aws_cloudwatch_dashboard" "shared_services" {
  dashboard_name = "shared-services-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/VPN", "TunnelState", { stat = "Maximum" }]
          ]
          period = 300
          stat   = "Maximum"
          region = "ap-northeast-1"
          title  = "VPN Tunnel State"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/TransitGateway", "BytesOut", { stat = "Sum" }]
          ]
          period = 300
          stat   = "Sum"
          region = "ap-northeast-1"
          title  = "Transit Gateway Traffic"
        }
      }
    ]
  })
}
