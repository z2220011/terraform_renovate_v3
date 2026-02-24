resource "aws_route53_zone" "main" {
  name = "prod.example.com"

  tags = {
    Name        = "prod-zone"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.prod.example.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.prod.example.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.prod.example.com"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}

resource "aws_route53_health_check" "alb" {
  fqdn              = aws_lb.main.dns_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name        = "prod-alb-health-check"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "prod.example.com"
  type    = "MX"
  ttl     = 300
  records = [
    "10 mail1.prod.example.com",
    "20 mail2.prod.example.com"
  ]
}

resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "prod.example.com"
  type    = "TXT"
  ttl     = 300
  records = [
    "v=spf1 include:_spf.google.com ~all"
  ]
}
