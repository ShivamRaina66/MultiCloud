provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "bankpro_sg" {
  name        = "bankpro-sg"
  description = "Allow SSH and app port"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bankpro_aws_vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.bankpro_sg.id]

  tags = {
    Name = "bankpro-aws-vm"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io ansible
              systemctl start docker
              systemctl enable docker
              EOF
}

output "aws_vm_public_ip" {
  value = aws_instance.bankpro_aws_vm.public_ip
}
