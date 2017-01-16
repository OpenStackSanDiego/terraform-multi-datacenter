variable "digitalocean_www_count" {
  description = "Number of DigitalOcean droplets to startup"
  default = "1"
}

variable "aws_region" {
  description = "Region to start up the instances"
  default = "us-east-1"
}

variable "aws_www_count" {
  description = "Number of AWS servers to startup"
  default = "2"
}
