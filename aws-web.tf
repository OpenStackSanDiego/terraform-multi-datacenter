
# populate this with the appropriate AMI for each region to be used
variable "aws_amis" {
  default = {
    us-east-1 = "ami-9be6f38c",
    us-west-1 = "ami-b73d6cd7"
  }
}

provider "aws" {
  region = "${var.aws_region}"
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

  vpc_security_group_ids = ["${aws_security_group.www.id}"]

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

  instances	= ["${aws_instance.www.*.id}"]

  subnets 	= ["${aws_instance.www.*.subnet_id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_security_group" "www" {

  description = "Allow SSH and HTTP ports 22 and 80"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

}
