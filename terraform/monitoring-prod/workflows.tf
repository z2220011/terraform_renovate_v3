resource "newrelic_workflow" "critical_alerts_workflow" {
  name                  = "Production Critical Alerts Workflow"
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
    channel_id = newrelic_notification_channel.pagerduty_critical.id
  }

  destination {
    channel_id = newrelic_notification_channel.email_critical.id
  }
}

resource "newrelic_workflow" "warning_alerts_workflow" {
  name                  = "Production Warning Alerts Workflow"
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

  destination {
    channel_id = newrelic_notification_channel.email_warning.id
  }
}

resource "newrelic_notification_channel" "slack_critical" {
  name    = "Production Slack Critical"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXX"
  }

  property {
    key   = "channelId"
    value = "prod-critical-alerts"
  }
}

resource "newrelic_notification_channel" "slack_warning" {
  name    = "Production Slack Warning"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.slack.com/services/T00000000/B00000000/YYYYYYYYYYYYYYYYYYYY"
  }

  property {
    key   = "channelId"
    value = "prod-warning-alerts"
  }
}

resource "newrelic_notification_channel" "pagerduty_critical" {
  name    = "Production PagerDuty"
  type    = "PAGERDUTY_SERVICE_INTEGRATION"
  product = "IINT"

  property {
    key   = "integrationKey"
    value = "prod-pagerduty-integration-key"
  }
}

resource "newrelic_notification_channel" "email_critical" {
  name    = "Production Email Critical"
  type    = "EMAIL"
  product = "IINT"

  property {
    key   = "recipients"
    value = "ops-team@example.com,oncall@example.com"
  }
}

resource "newrelic_notification_channel" "email_warning" {
  name    = "Production Email Warning"
  type    = "EMAIL"
  product = "IINT"

  property {
    key   = "recipients"
    value = "ops-team@example.com"
  }
}

resource "newrelic_workflow" "apm_workflow" {
  name                  = "Production APM Alerts"
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
  name    = "Production Slack APM"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.slack.com/services/T00000000/B00000000/ZZZZZZZZZZZZZZZZZZZZ"
  }

  property {
    key   = "channelId"
    value = "prod-apm-alerts"
  }
}

resource "newrelic_workflow" "infrastructure_workflow" {
  name                  = "Production Infrastructure Alerts"
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
  name    = "Production Slack Infrastructure"
  type    = "SLACK"
  product = "IINT"

  property {
    key   = "url"
    value = "https://hooks.slack.com/services/T00000000/B00000000/AAAAAAAAAAAAAAAAAAAA"
  }

  property {
    key   = "channelId"
    value = "prod-infra-alerts"
  }
}
