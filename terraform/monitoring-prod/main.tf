resource "newrelic_alert_policy" "main" {
  name                = "Production Application Monitoring"
  incident_preference = "PER_CONDITION_AND_TARGET"
}

resource "newrelic_alert_channel" "email" {
  name = "prod-email-notifications"
  type = "email"

  config {
    recipients              = "ops-team@example.com"
    include_json_attachment = "true"
  }
}

resource "newrelic_alert_policy_channel" "main_email" {
  policy_id  = newrelic_alert_policy.main.id
  channel_ids = [
    newrelic_alert_channel.email.id
  ]
}

resource "newrelic_nrql_alert_condition" "high_response_time" {
  policy_id = newrelic_alert_policy.main.id
  name      = "High Response Time"
  type      = "static"
  enabled   = true

  nrql {
    query = "SELECT average(duration) FROM Transaction WHERE appName = 'ProductionApp'"
  }

  critical {
    operator              = "above"
    threshold             = 5.0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 3.0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  violation_time_limit_seconds = 3600
}

resource "newrelic_nrql_alert_condition" "error_rate" {
  policy_id = newrelic_alert_policy.main.id
  name      = "High Error Rate"
  type      = "static"
  enabled   = true

  nrql {
    query = "SELECT percentage(count(*), WHERE error IS true) FROM Transaction WHERE appName = 'ProductionApp'"
  }

  critical {
    operator              = "above"
    threshold             = 5.0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  violation_time_limit_seconds = 3600
}

resource "newrelic_synthetics_monitor" "website" {
  name      = "Production Website Check"
  type      = "SIMPLE"
  frequency = 5
  status    = "ENABLED"
  locations = ["AWS_AP_NORTHEAST_1"]

  uri                       = "https://www.example.com"
  validation_string         = "Welcome"
  verify_ssl                = true
  bypass_head_request       = false
  treat_redirect_as_failure = false
}
