resource "newrelic_alert_policy" "apm_policy" {
  name                = "Production APM Policy"
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
    query = "FROM Transaction SELECT average(duration) WHERE appName = 'production-app'"
  }

  critical {
    operator              = "above"
    threshold             = 1.0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 300
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
    query = "FROM Transaction SELECT percentage(count(*), WHERE error IS true) WHERE appName = 'production-app'"
  }

  critical {
    operator              = "above"
    threshold             = 5.0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 2.0
    threshold_duration    = 300
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
    query = "FROM Transaction SELECT apdex(duration, t: 0.5) WHERE appName = 'production-app'"
  }

  critical {
    operator              = "below"
    threshold             = 0.7
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "below"
    threshold             = 0.85
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "high_throughput_drop" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "baseline"
  name                         = "Significant Throughput Drop"
  description                  = "Alert when throughput drops significantly"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  baseline_direction           = "lower_only"

  nrql {
    query = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName = 'production-app'"
  }

  critical {
    operator              = "above"
    threshold             = 3
    threshold_duration    = 300
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
    query = "FROM Transaction SELECT average(databaseDuration) WHERE appName = 'production-app'"
  }

  critical {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 0.3
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "memory_leak_detection" {
  policy_id                    = newrelic_alert_policy.apm_policy.id
  type                         = "static"
  name                         = "Potential Memory Leak"
  description                  = "Alert on steadily increasing memory usage"
  enabled                      = true
  violation_time_limit_seconds = 7200
  aggregation_window           = 300
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM Transaction SELECT average(memoryUsageMB) WHERE appName = 'production-app'"
  }

  critical {
    operator              = "above"
    threshold             = 2048
    threshold_duration    = 1800
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 1536
    threshold_duration    = 1800
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
    query = "FROM Transaction SELECT count(*) WHERE appName = 'production-app' AND httpResponseCode LIKE '5%'"
  }

  critical {
    operator              = "above"
    threshold             = 50
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 20
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}
