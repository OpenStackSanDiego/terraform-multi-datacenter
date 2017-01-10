
provider "digitalocean" { }

resource "digitalocean_ssh_key" "www" {
    name = "www"
    public_key = "${file("./id_rsa.pub")}"
}

# For a list of images:
# curl -X GET --silent "https://api.digitalocean.com/v2/images?per_page=999" -H "Authorization: Bearer $DIGITALOCEAN_TOKEN"

resource "digitalocean_droplet" "web" {
  count = 0
  image = "centos-7-x64"
  name = "web-1"
  region = "nyc1"
  size = "512mb"
  ssh_keys = ["${digitalocean_ssh_key.www.id}"]

  connection {
    user = "root"
    private_key = "${file("./id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install epel-release",
      "sudo yum -y install nginx",
      "sudo service nginx start",
      "sudo chmod 666 /usr/share/nginx/html/index.html",
      "echo Welcome to `hostname` > /usr/share/nginx/html/index.html",
      "sudo chmod 644 /usr/share/nginx/html/index.html"
    ]
  }

}
