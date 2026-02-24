resource "aws_lb" "shared" {
  name               = "shared-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.private[*].id

  enable_deletion_protection = true
  enable_http2              = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name        = "shared-alb"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "alb" {
  name        = "shared-alb-sg"
  description = "Security group for shared services ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "shared-alb-sg"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_lb_target_group" "shared_services" {
  name     = "shared-services-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "shared-services-tg"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.shared.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.shared.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_services.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.shared.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_acm_certificate" "shared" {
  domain_name       = "shared.internal.example.com"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.shared.internal.example.com"
  ]

  tags = {
    Name        = "shared-cert"
    Environment = "shared"
    ManagedBy   = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}
