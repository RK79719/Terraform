/*data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["099720109477"]

    filter {
    name = "name"
    values = ["*hvm*"]
  }

}*/


resource "aws_instance" "ec2-nginx" {
  //ami = data.aws_ami.app_ami.id
  ami                         = "ami-0287a05f0ef0e9d9a"
  instance_type               = "t2.micro"
  key_name                    = "teju-key"
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id]
  subnet_id                   = var.public_subnet_id

  tags = {
    Name = "nginx-instance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("../../teju-key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      // "sudo amazon-linux-extras install nginx1 -y",
      "sudo apt-get install nginx -y",
      "sudo systemctl start nginx",
    ]
  }
}

resource "aws_ami_from_instance" "example" {
  name               = "nginx-ami"
  source_instance_id = aws_instance.ec2-nginx.id

}

