variable "aws_region" {
  description = "AWS region to startup environment"
  default = "us-east-1"
}

variable "aws_www_count" {
  description = "Number of AWS web servers to startup"
#  default = "0"
}

variable "aws_amis" {
  default = {
    us-east-1 = "ami-9be6f38c"
  }
}

resource "aws_instance" "www" {
  count = "${var.aws_www_count}"

  tags {
    Name = "${format("www-%03d", count.index + 1)}"
  }

  connection {
    user = "ec2-user"
    private_key = "${file("./id_rsa")}"
  }

  instance_type = "t2.micro"

  ami = "${lookup(var.aws_amis, var.aws_region)}"
 
  key_name = "${aws_key_pair.auth.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install nginx",
      "sudo service nginx start",
      "sudo chmod 666 /usr/share/nginx/html/index.html",
      "echo Welcome to `hostname` > /usr/share/nginx/html/index.html",
      "sudo chmod 644 /usr/share/nginx/html/index.html"
    ]
  }
}

resource "aws_key_pair" "auth" {
  count = "${signum(var.aws_www_count)}"
  key_name = "terraform"
  public_key = "${file("./id_rsa.pub")}"
}


resource "aws_elb" "www" {
  # if there is at least one www instance create the elb
  count = "${signum(var.aws_www_count)}"

  name = "www"

  instances       = ["${aws_instance.www.*.id}"]
  availability_zones = ["us-east-1a","us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
