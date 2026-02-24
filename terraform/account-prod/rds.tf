resource "aws_db_subnet_group" "main" {
  name       = "prod-db-subnet-group"
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "prod-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier     = "prod-database"
  engine         = "postgres"
  engine_version = "14.7"
  instance_class = "db.t3.medium"

  allocated_storage     = 100
  max_allocated_storage = 500
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "production"
  username = "dbadmin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  performance_insights_enabled    = true
  monitoring_interval             = 60

  skip_final_snapshot = false
  final_snapshot_identifier = "prod-db-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  tags = {
    Name        = "prod-database"
    Environment = "production"
  }
}

resource "aws_security_group" "rds" {
  name        = "prod-rds-sg"
  description = "Security group for production RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-rds-sg"
  }
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
