resource "newrelic_alert_policy" "dev" {
  name                = "Development Application Monitoring"
  incident_preference = "PER_POLICY"
}

resource "newrelic_alert_channel" "slack" {
  name = "dev-slack-notifications"
  type = "slack"

  config {
    url     = "https://hooks.example.com/services/YOUR_WEBHOOK_HERE"
    channel = "#dev-alerts"
  }
}

resource "newrelic_alert_policy_channel" "dev_slack" {
  policy_id = newrelic_alert_policy.dev.id
  channel_ids = [
    newrelic_alert_channel.slack.id
  ]
}

resource "newrelic_nrql_alert_condition" "cpu_usage" {
  policy_id = newrelic_alert_policy.dev.id
  name      = "High CPU Usage"
  type      = "static"
  enabled   = true

  nrql {
    query = "SELECT average(cpuPercent) FROM SystemSample WHERE hostname LIKE 'dev-%'"
  }

  critical {
    operator              = "above"
    threshold             = 80.0
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  violation_time_limit_seconds = 3600
}

resource "newrelic_synthetics_monitor" "dev_api" {
  name      = "Development API Check"
  type      = "SIMPLE"
  frequency = 10
  status    = "ENABLED"
  locations = ["AWS_AP_NORTHEAST_1"]

  uri                 = "https://api-dev.example.com/health"
  validation_string   = "ok"
  verify_ssl          = false
}
