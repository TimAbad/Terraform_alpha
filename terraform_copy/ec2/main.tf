
provider "aws" {
	region = "us-west-2"
}

data "aws_availability_zones" "available" {}

resource "aws_key_pair" "IEkeys" {
	key_name = "IEkeys"
	public_key = "${file(var.my_public_key)}"
	
}

resource "aws_instance" "IEinstance" {
  count = 2
  ami                    = "ami-036d46416a34a611c"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.security_group}"]
  key_name               = "${aws_key_pair.IEkeys.id}"
  user_data = "${data.template_file.init.rendered}"
  subnet_id = "${element(var.subnets, count.index)}"
  skip_final_snapshot = true

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key /tmp/id_rsa /home/tim/ansible_test/apache_install.yml"
  }
}

/*
data "template_file" "init" {
  template = "${file("${path.module}/userdata.tpl")}"
}*/

