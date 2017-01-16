output "AWS IP(s)" {
  value = ["${aws_instance.www.*.public_ip}"]
}

output "AWS Elastic Load Balancer" {
  value = "${aws_elb.www.ip}"
}

output "Digital Ocean IP(s)" {
  value = ["${digitalocean_droplet.www.*.ipv4_address}"]
}
