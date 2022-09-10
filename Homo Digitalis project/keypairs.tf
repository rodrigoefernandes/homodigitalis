#workload and db linux keypair

resource "tls_private_key" "linux_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "linux_key_pair" {
  key_name   = "linux_key_pair"
  public_key = tls_private_key.linux_key_pair.public_key_openssh
}

resource "local_file" "linux_key_pair" {
  filename = "${aws_key_pair.linux_key_pair.key_name}.pem"
  content  = tls_private_key.linux_key_pair.private_key_pem
}

