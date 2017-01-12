
data "aws_route53_zone" "selected" {
  name = "acme.com."
  private_zone = true
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "www.${data.aws_route53_zone.selected.name}"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.www.dns_name}"]
}
