resource "aws_security_group" "bastion" {
  name        = "${local.resource_tag}-bastion-sg"
  description = "Allows SSH access to the bastion host."
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from admin CIDR"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web" {
  name        = "${local.resource_tag}-web-sg"
  description = "Allows HTTP access to the public web server."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from admin CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "${local.resource_tag}-app-sg"
  description = "Allows Node.js API traffic from the web tier and SSH from bastion."
  vpc_id      = aws_vpc.main.id

  ingress {
    description                = "API access from web tier"
    from_port                  = 3000
    to_port                    = 3000
    protocol                   = "tcp"
    source_security_group_id   = aws_security_group.web.id
  }

  ingress {
    description                = "SSH from bastion host"
    from_port                  = 22
    to_port                    = 22
    protocol                   = "tcp"
    source_security_group_id   = aws_security_group.bastion.id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "${local.resource_tag}-db-sg"
  description = "Allows MySQL from the application tier only."
  vpc_id      = aws_vpc.main.id

  ingress {
    description              = "MySQL from app tier"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    source_security_group_id = aws_security_group.app.id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
