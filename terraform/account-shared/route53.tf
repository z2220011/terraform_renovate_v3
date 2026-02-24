resource "aws_route53_zone" "private" {
  name = "shared.internal.example.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Name        = "shared-private-zone"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "services.shared.internal.example.com"
  type    = "A"

  alias {
    name                   = aws_lb.shared.dns_name
    zone_id                = aws_lb.shared.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "vpn_endpoint" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "vpn.shared.internal.example.com"
  type    = "A"
  ttl     = 300
  records = ["10.0.100.10"]
}

resource "aws_route53_record" "directory_service" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "ad.shared.internal.example.com"
  type    = "A"
  ttl     = 300
  records = [
    "10.0.100.20",
    "10.0.101.20"
  ]
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.shared.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.private.zone_id
}

resource "aws_acm_certificate_validation" "shared" {
  certificate_arn         = aws_acm_certificate.shared.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}

resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "shared-inbound-resolver"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.resolver.id]

  ip_address {
    subnet_id = aws_subnet.private[0].id
  }

  ip_address {
    subnet_id = aws_subnet.private[1].id
  }

  tags = {
    Name        = "shared-inbound-resolver"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "resolver" {
  name        = "shared-resolver-sg"
  description = "Security group for Route53 resolver endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "DNS from VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "DNS from VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "shared-resolver-sg"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}
