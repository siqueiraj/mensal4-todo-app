resource "aws_security_group" "app" {
  name        = "mensal4-app-sg"
  description = "Seguranca do servidor da aplicacao"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH administrativo"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mensal4-app-sg"
  }
}

resource "aws_security_group" "database" {
  name        = "mensal4-db-sg"
  description = "Seguranca do servidor MongoDB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MongoDB somente pela aplicacao"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  ingress {
    description     = "SSH pelo servidor da aplicacao"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mensal4-db-sg"
  }
}

