resource "newrelic_one_dashboard" "application_overview" {
  name = "Production Application Overview"

  page {
    name = "Application Performance"

    widget_billboard {
      title  = "Response Time"
      row    = 1
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT average(duration) WHERE appName = 'production-app'"
      }
    }

    widget_line {
      title  = "Throughput"
      row    = 1
      column = 5
      width  = 8
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName = 'production-app' TIMESERIES"
      }
    }

    widget_billboard {
      title  = "Error Rate"
      row    = 4
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT percentage(count(*), WHERE error IS true) WHERE appName = 'production-app'"
      }
    }

    widget_line {
      title  = "Apdex Score"
      row    = 4
      column = 5
      width  = 8
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT apdex(duration, t: 0.5) WHERE appName = 'production-app' TIMESERIES"
      }
    }
  }

  page {
    name = "Database Performance"

    widget_line {
      title  = "Database Response Time"
      row    = 1
      column = 1
      width  = 6
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT average(databaseDuration) WHERE appName = 'production-app' TIMESERIES"
      }
    }

    widget_line {
      title  = "Database Call Count"
      row    = 1
      column = 7
      width  = 6
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName = 'production-app' AND databaseDuration IS NOT NULL TIMESERIES"
      }
    }

    widget_table {
      title  = "Slowest Database Queries"
      row    = 4
      column = 1
      width  = 12
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT average(databaseDuration), count(*) WHERE appName = 'production-app' FACET databaseStatement LIMIT 10"
      }
    }
  }
}

resource "newrelic_one_dashboard" "infrastructure_overview" {
  name = "Production Infrastructure Overview"

  page {
    name = "Server Metrics"

    widget_line {
      title  = "CPU Usage"
      row    = 1
      column = 1
      width  = 6
      height = 3

      nrql_query {
        query = "FROM SystemSample SELECT average(cpuPercent) WHERE environment = 'production' FACET hostname TIMESERIES"
      }
    }

    widget_line {
      title  = "Memory Usage"
      row    = 1
      column = 7
      width  = 6
      height = 3

      nrql_query {
        query = "FROM SystemSample SELECT average(memoryUsedPercent) WHERE environment = 'production' FACET hostname TIMESERIES"
      }
    }

    widget_line {
      title  = "Disk Usage"
      row    = 4
      column = 1
      width  = 6
      height = 3

      nrql_query {
        query = "FROM StorageSample SELECT average(diskUsedPercent) WHERE environment = 'production' FACET device TIMESERIES"
      }
    }

    widget_line {
      title  = "Network Traffic"
      row    = 4
      column = 7
      width  = 6
      height = 3

      nrql_query {
        query = "FROM NetworkSample SELECT average(receiveBytesPerSecond), average(transmitBytesPerSecond) WHERE environment = 'production' TIMESERIES"
      }
    }
  }
}

resource "newrelic_one_dashboard" "business_metrics" {
  name = "Production Business Metrics"

  page {
    name = "Key Metrics"

    widget_billboard {
      title  = "Active Users"
      row    = 1
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = "FROM PageView SELECT uniqueCount(session) WHERE appName = 'production-app' SINCE 1 hour ago"
      }
    }

    widget_billboard {
      title  = "Total Transactions"
      row    = 1
      column = 5
      width  = 4
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT count(*) WHERE appName = 'production-app' AND transactionType = 'purchase' SINCE 1 hour ago"
      }
    }

    widget_billboard {
      title  = "Revenue (Last Hour)"
      row    = 1
      column = 9
      width  = 4
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT sum(revenue) WHERE appName = 'production-app' SINCE 1 hour ago"
      }
    }

    widget_line {
      title  = "Transaction Trend"
      row    = 4
      column = 1
      width  = 12
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT count(*) WHERE appName = 'production-app' AND transactionType = 'purchase' TIMESERIES AUTO"
      }
    }
  }
}
