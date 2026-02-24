resource "newrelic_workflow" "critical_alerts_workflow" {
  name                  = "Development Critical Alerts Workflow"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"
  enabled               = true

  issues_filter {
    name = "Filter by priority"
    type = "FILTER"

    predicate {
      attribute = "priority"
      operator  = "EQUAL"
      values    = ["CRITICAL"]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack_critical.id
  }

  destination {
    channel_id = newrelic_notification_channel.email_critical.id
  }
}

resource "newrelic_workflow" "warning_alerts_workflow" {
  name                  = "Development Warning Alerts Workflow"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"
  enabled               = true

  issues_filter {
    name = "Filter by priority"
    type = "FILTER"

    predicate {
      attribute = "priority"
      operator  = "EQUAL"
      values    = ["WARNING"]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack_warning.id
  }
}

resource "newrelic_notification_channel" "slack_critical" {
  name    = "Development Slack Critical"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.example.com/services/YOUR_WEBHOOK_HERE"
  }

  property {
    key   = "channelId"
    value = "dev-critical-alerts"
  }
}

resource "newrelic_notification_channel" "slack_warning" {
  name    = "Development Slack Warning"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.example.com/services/YOUR_WEBHOOK_HERE"
  }

  property {
    key   = "channelId"
    value = "dev-warning-alerts"
  }
}

resource "newrelic_notification_channel" "email_critical" {
  name    = "Development Email Critical"
  type    = "EMAIL"
  product = "IINT"

  property {
    key   = "recipients"
    value = "dev-team@example.com"
  }
}

resource "newrelic_workflow" "apm_workflow" {
  name                  = "Development APM Alerts"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"
  enabled               = true

  issues_filter {
    name = "Filter APM policy"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values    = [newrelic_alert_policy.apm_policy.id]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack_apm.id
  }
}

resource "newrelic_notification_channel" "slack_apm" {
  name    = "Development Slack APM"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.example.com/services/YOUR_WEBHOOK_HERE"
  }

  property {
    key   = "channelId"
    value = "dev-apm-alerts"
  }
}

resource "newrelic_workflow" "infrastructure_workflow" {
  name                  = "Development Infrastructure Alerts"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"
  enabled               = true

  issues_filter {
    name = "Filter infrastructure policy"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values    = [newrelic_alert_policy.infrastructure_policy.id]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack_infrastructure.id
  }
}

resource "newrelic_notification_channel" "slack_infrastructure" {
  name    = "Development Slack Infrastructure"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.example.com/services/YOUR_WEBHOOK_HERE"
  }

  property {
    key   = "channelId"
    value = "dev-infra-alerts"
  }
}

resource "newrelic_workflow" "debugging_workflow" {
  name                  = "Development Debugging Workflow"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"
  enabled               = true

  issues_filter {
    name = "Filter all development alerts"
    type = "FILTER"

    predicate {
      attribute = "labels.environment"
      operator  = "EQUAL"
      values    = ["development"]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack_debugging.id
  }
}

resource "newrelic_notification_channel" "slack_debugging" {
  name    = "Development Slack Debugging"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.example.com/services/YOUR_WEBHOOK_HERE"
  }

  property {
    key   = "channelId"
    value = "dev-debugging"
  }
}
