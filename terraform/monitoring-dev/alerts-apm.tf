resource "newrelic_alert_policy" "apm_policy" {
  name                = "Development APM Policy"
  incident_preference = "PER_CONDITION"
}

resource "newrelic_nrql_alert_condition" "high_response_time" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "static"
  name                         = "High Response Time"
  description                  = "Alert when average response time exceeds threshold"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM Transaction SELECT average(duration) WHERE appName = 'development-app'"
  }

  critical {
    operator              = "above"
    threshold             = 3.0
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 2.0
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "high_error_rate" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "static"
  name                         = "High Error Rate"
  description                  = "Alert when error rate exceeds threshold"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM Transaction SELECT percentage(count(*), WHERE error IS true) WHERE appName = 'development-app'"
  }

  critical {
    operator              = "above"
    threshold             = 15.0
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 10.0
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "low_apdex" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "static"
  name                         = "Low Apdex Score"
  description                  = "Alert when Apdex score falls below threshold"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM Transaction SELECT apdex(duration, t: 1.0) WHERE appName = 'development-app'"
  }

  critical {
    operator              = "below"
    threshold             = 0.5
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "below"
    threshold             = 0.7
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "slow_database_queries" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "static"
  name                         = "Slow Database Queries"
  description                  = "Alert when database query time is too high"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM Transaction SELECT average(databaseDuration) WHERE appName = 'development-app'"
  }

  critical {
    operator              = "above"
    threshold             = 1.5
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 1.0
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "excessive_errors" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "static"
  name                         = "Excessive Application Errors"
  description                  = "Alert on high count of errors"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM TransactionError SELECT count(*) WHERE appName = 'development-app'"
  }

  critical {
    operator              = "above"
    threshold             = 100
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 50
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "http_5xx_errors" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "static"
  name                         = "High 5xx Error Rate"
  description                  = "Alert on increased server errors"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE appName = 'development-app' AND httpResponseCode LIKE '5%'"
  }

  critical {
    operator              = "above"
    threshold             = 100
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 50
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "transaction_timeout" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "static"
  name                         = "Transaction Timeouts"
  description                  = "Alert on transaction timeouts"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM Transaction SELECT count(*) WHERE appName = 'development-app' AND duration > 30"
  }

  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}
