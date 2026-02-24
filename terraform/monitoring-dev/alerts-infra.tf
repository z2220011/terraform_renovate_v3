resource "newrelic_alert_policy" "infrastructure_policy" {
  name                = "Development Infrastructure Policy"
  incident_preference = "PER_CONDITION"
}

resource "newrelic_nrql_alert_condition" "high_cpu_usage" {
  policy_id                    = newrelic_alert_policy.infrastructure_policy.id
  type                         = "static"
  name                         = "High CPU Usage"
  description                  = "Alert when CPU usage exceeds threshold"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM SystemSample SELECT average(cpuPercent) WHERE environment = 'development' FACET hostname"
  }

  critical {
    operator              = "above"
    threshold             = 95
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "high_memory_usage" {
  policy_id                    = newrelic_alert_policy.infrastructure_policy.id
  type                         = "static"
  name                         = "High Memory Usage"
  description                  = "Alert when memory usage exceeds threshold"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM SystemSample SELECT average(memoryUsedPercent) WHERE environment = 'development' FACET hostname"
  }

  critical {
    operator              = "above"
    threshold             = 98
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 95
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "high_disk_usage" {
  policy_id                    = newrelic_alert_policy.infrastructure_policy.id
  type                         = "static"
  name                         = "High Disk Usage"
  description                  = "Alert when disk usage exceeds threshold"
  enabled                      = true
  violation_time_limit_seconds = 7200
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM StorageSample SELECT average(diskUsedPercent) WHERE environment = 'development' FACET hostname, device"
  }

  critical {
    operator              = "above"
    threshold             = 95
    threshold_duration    = 900
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 900
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "host_not_reporting" {
  policy_id                    = newrelic_alert_policy.infrastructure_policy.id
  type                         = "static"
  name                         = "Host Not Reporting"
  description                  = "Alert when host stops reporting data"
  enabled                      = true
  violation_time_limit_seconds = 7200
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM SystemSample SELECT uniqueCount(hostname) WHERE environment = 'development'"
  }

  critical {
    operator              = "below"
    threshold             = 1
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "high_network_errors" {
  policy_id                    = newrelic_alert_policy.infrastructure_policy.id
  type                         = "static"
  name                         = "High Network Error Rate"
  description                  = "Alert on network errors"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM NetworkSample SELECT rate(sum(receiveErrorsPerSecond + transmitErrorsPerSecond), 1 minute) WHERE environment = 'development' FACET hostname"
  }

  critical {
    operator              = "above"
    threshold             = 500
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 250
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "high_load_average" {
  policy_id                    = newrelic_alert_policy.infrastructure_policy.id
  type                         = "static"
  name                         = "High Load Average"
  description                  = "Alert when system load is too high"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM SystemSample SELECT average(loadAverageOneMinute) WHERE environment = 'development' FACET hostname"
  }

  critical {
    operator              = "above"
    threshold             = 15
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 12
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "disk_io_high" {
  policy_id                    = newrelic_alert_policy.infrastructure_policy.id
  type                         = "static"
  name                         = "High Disk I/O Utilization"
  description                  = "Alert when disk I/O is saturated"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 60
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM StorageSample SELECT average(ioUtilizationPercent) WHERE environment = 'development' FACET hostname, device"
  }

  critical {
    operator              = "above"
    threshold             = 98
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 95
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "container_restart" {
  policy_id                    = newrelic_alert_policy.infrastructure_policy.id
  type                         = "static"
  name                         = "Frequent Container Restarts"
  description                  = "Alert on containers restarting frequently"
  enabled                      = true
  violation_time_limit_seconds = 3600
  aggregation_window           = 300
  aggregation_method           = "event_flow"

  nrql {
    query = "FROM ContainerSample SELECT uniqueCount(containerId) WHERE environment = 'development' AND restartCount > 0"
  }

  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}
