data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = aws_key_pair.ssh.key_name
  associate_public_ip_address = true
  user_data                   = file("${path.module}/user_data/bastion.sh")

  tags = {
    Name = "${local.resource_tag}-bastion"
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = aws_key_pair.ssh.key_name
  associate_public_ip_address = false
  user_data                   = templatefile("${path.module}/user_data/app.sh.tpl", {
    db_endpoint  = aws_db_instance.appdb.address
    db_username  = var.db_username
    db_password  = var.db_password
    db_name      = var.db_name
  })

  tags = {
    Name = "${local.resource_tag}-app"
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = aws_key_pair.ssh.key_name
  associate_public_ip_address = true
  user_data                   = templatefile("${path.module}/user_data/web.sh.tpl", {
    app_private_ip = aws_instance.app.private_ip
  })

  tags = {
    Name = "${local.resource_tag}-web"
  }
}
