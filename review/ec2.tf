provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0aaa5410833273cfe"  
  instance_type = "t2.micro"

  tags = {
    Name = "My EC2 Instance"
  }

  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    key_pair    = "Demo"
    timeout     = "2m"
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}

resource "aws_security_group" "ssh" {
  name_prefix = "ssh_access"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
