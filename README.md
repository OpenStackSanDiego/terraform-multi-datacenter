# terraform-multi-datacenter
Using Terraform to deploy Linux based web servers across multi data center providers

Clone this repo to a local host with terraform installed.
Terraform is available at: https://www.terraform.io/downloads.html
Clone this repo with the command: git clone https://github.com/OpenStackSanDiego/terraform-multi-datacenter.git

Setup the cloud credentials
Download your AWS keys from: https://console.aws.amazon.com/iam/home?region=us-east-1#/security_credential
You'll need the 'Access Id Key' and 'Secret Access Key'
Download the Digital Ocean key from: https://cloud.digitalocean.com/settings/api/tokens
Save these keys into "keys.sh"
Read the "key.sh" file into environment variables: source keys.sh

Setup the virtual server keys
This key will be installed into each VM as an authorized key
Generate a new keypair with the command: ssh-keygen -f ./id_rsa -N ''
This will generate a keypair 'id_rsa' and 'id_rsa.pub'

Validate: terraform plan
Execute: terraform apply

The IP address of the AWS ELB (elastic load balancer) and individual instance IP addresses will be displayed at the conclusion of the terraform. Each of these IP address can be accessed with a web browser to validate that the individual servers and load balancer are working.

To log into any individual instance, execute the following command: ssh -i ./id_rsa <instance_ip>

To tear down the network, execute: terraform destroy








