resource "aws_db_subnet_group" "db" {
  name       = "${local.resource_tag}-db-subnet-group"
  subnet_ids = [aws_subnet.db.id, aws_subnet.db2.id]

  tags = {
    Name = "${local.resource_tag}-db-subnet-group"
  }
}

resource "aws_db_instance" "appdb" {
  allocated_storage    = var.db_allocated_storage
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot  = true
  publicly_accessible   = false
  backup_retention_period = 7
  deletion_protection   = false
  storage_encrypted     = true

  tags = {
    Name = "${local.resource_tag}-rds"
  }
}
