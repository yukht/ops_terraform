/*
data "aws_ami" "debian-ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*debian-11*"]
#    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

}

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

     owners = ["136693071363"] # Debian
#    owners = ["099720109477"] # Canonical (Ubuntu)

}
*/
/*
data "aws_ami" "ubuntu" {
  filter {
  name	= "name"
  values = ["*ubuntu/images/*22.04*"]
  }
  most_recent = true

}
*/

