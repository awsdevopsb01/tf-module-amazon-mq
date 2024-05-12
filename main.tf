resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "rabbitmq"
    from_port        = var.port_no
    to_port          = var.port_no
    protocol         = "tcp"
    cidr_blocks      = var.allow_db_cidr
  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.bastion_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {Name="${var.env}-${var.name}-instance" })
}

resource "aws_instance" "rabbitmq" {
  ami = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = var.subnets[0]
  tags = merge(var.tags, {Name="${var.env}-${var.name}-instance" })

  root_block_device {
    encrypted = true
    kms_key_id = var.kms_arn
  }
  user_data = base64encode("${path.module}/userdata.sh")
}

resource "aws_route53_record" "dnsrecord" {
  zone_id = var.domain_id
  name    = "rabbitmq-${var.env}"
  type    = "A"
  ttl     = 30
  records = [aws_instance.rabbitmq.private_ip]
}