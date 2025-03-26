provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow HTTP y SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "app_server" {
  ami             = "ami-05b10e08d247fb927" # Amazon Linux
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable docker
    yum install -y docker git
    service docker start
    usermod -aG docker ec2-user
    curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    cd /home/ec2-user
    git clone https://github.com/pabcrudev/express-docker-terraform-aws.git
    cd express-docker-terraform-aws

    docker build -t app_server .
    docker run -d -p 80:80 app_server
    EOF

  tags = {
    Name = "AppServer"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}
