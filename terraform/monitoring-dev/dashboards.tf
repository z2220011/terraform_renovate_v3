resource "newrelic_one_dashboard" "application_overview" {
  name = "Development Application Overview"

  page {
    name = "Application Performance"

    widget_billboard {
      title  = "Response Time"
      row    = 1
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT average(duration) WHERE appName = 'development-app'"
      }
    }

    widget_line {
      title  = "Throughput"
      row    = 1
      column = 5
      width  = 8
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName = 'development-app' TIMESERIES"
      }
    }

    widget_billboard {
      title  = "Error Rate"
      row    = 4
      column = 1
      width  = 4
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT percentage(count(*), WHERE error IS true) WHERE appName = 'development-app'"
      }
    }

    widget_line {
      title  = "Apdex Score"
      row    = 4
      column = 5
      width  = 8
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT apdex(duration, t: 1.0) WHERE appName = 'development-app' TIMESERIES"
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
        query = "FROM Transaction SELECT average(databaseDuration) WHERE appName = 'development-app' TIMESERIES"
      }
    }

    widget_line {
      title  = "Database Call Count"
      row    = 1
      column = 7
      width  = 6
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName = 'development-app' AND databaseDuration IS NOT NULL TIMESERIES"
      }
    }

    widget_table {
      title  = "Slowest Database Queries"
      row    = 4
      column = 1
      width  = 12
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT average(databaseDuration), count(*) WHERE appName = 'development-app' FACET databaseStatement LIMIT 10"
      }
    }
  }
}

resource "newrelic_one_dashboard" "infrastructure_overview" {
  name = "Development Infrastructure Overview"

  page {
    name = "Server Metrics"

    widget_line {
      title  = "CPU Usage"
      row    = 1
      column = 1
      width  = 6
      height = 3

      nrql_query {
        query = "FROM SystemSample SELECT average(cpuPercent) WHERE environment = 'development' FACET hostname TIMESERIES"
      }
    }

    widget_line {
      title  = "Memory Usage"
      row    = 1
      column = 7
      width  = 6
      height = 3

      nrql_query {
        query = "FROM SystemSample SELECT average(memoryUsedPercent) WHERE environment = 'development' FACET hostname TIMESERIES"
      }
    }

    widget_line {
      title  = "Disk Usage"
      row    = 4
      column = 1
      width  = 6
      height = 3

      nrql_query {
        query = "FROM StorageSample SELECT average(diskUsedPercent) WHERE environment = 'development' FACET device TIMESERIES"
      }
    }

    widget_line {
      title  = "Network Traffic"
      row    = 4
      column = 7
      width  = 6
      height = 3

      nrql_query {
        query = "FROM NetworkSample SELECT average(receiveBytesPerSecond), average(transmitBytesPerSecond) WHERE environment = 'development' TIMESERIES"
      }
    }
  }
}

resource "newrelic_one_dashboard" "debugging_dashboard" {
  name = "Development Debugging Dashboard"

  page {
    name = "Error Analysis"

    widget_table {
      title  = "Recent Errors"
      row    = 1
      column = 1
      width  = 12
      height = 4

      nrql_query {
        query = "FROM TransactionError SELECT count(*) WHERE appName = 'development-app' FACET `error.class`, `error.message` LIMIT 20 SINCE 1 hour ago"
      }
    }

    widget_line {
      title  = "Error Trend"
      row    = 5
      column = 1
      width  = 12
      height = 3

      nrql_query {
        query = "FROM TransactionError SELECT count(*) WHERE appName = 'development-app' TIMESERIES FACET `error.class`"
      }
    }
  }

  page {
    name = "Performance Profiling"

    widget_table {
      title  = "Slowest Transactions"
      row    = 1
      column = 1
      width  = 12
      height = 4

      nrql_query {
        query = "FROM Transaction SELECT average(duration), count(*) WHERE appName = 'development-app' FACET name LIMIT 20"
      }
    }

    widget_bar {
      title  = "Transaction Duration Distribution"
      row    = 5
      column = 1
      width  = 12
      height = 3

      nrql_query {
        query = "FROM Transaction SELECT histogram(duration, 10, 20) WHERE appName = 'development-app'"
      }
    }
  }
}
