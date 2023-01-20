data "aws_ami" "debian-11" {
  most_recent = true
  owners = ["136693071363"]

  filter {
  name	= "name"
  values = ["*debian-11-amd64-20221219-1234"] # Only specifying full path to AMI will free-tier be returned
  }

}

resource "aws_key_pair" "terraform-remote" {
  key_name   = "terraform-remote"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvhlm+M8glIRQMCqZT9moiYvvsJ+uI8qlUZ/hCK/Xd6CqKPn9rLvhuHxJ+nRFRL7+OOnyH8j7i4nMSvyRLpnQMuuSIpKJJdYqNx2HfburHwlozQ+MO2DCa+XTSz4/X5jD0XhztF1UAPwsTLNBscUplEilzJ2xPyZREPU/XWSNOJcgSODi/yYk4nd56mRcjOwFiwa36Z0UgJg3VStHDMiowR++iOwPBokdzb1S+MyIWJWOFChKJSFnnW6JTEyGnBSsmj10Bxu72/FA3Wss/Re14MwJKZ+T9RSBNzqwGaRTTl7XF1Pe6K6dWegJ8zJ4YjgUb85wmYdSUi454VjdgYm1nht1/aeW4y8/OrnVvbztZJYfl+bCc1HquNOGKhuMVllF1TbapHxBAU8S1rabbSVcrquXyTrQlGDrE21rpg6puIv1sEzVBrx6CLUbBglc0bA51nR0hZS1mAfVSiEpThmiZgY4WPsJzFYnenzoupsO4RjbO32BA92h8PZzRlBlIQOE= root@terraform"
}

# Create free-tier instance
resource "aws_instance" "microdebian1" {
  ami           = data.aws_ami.debian-11.id
  instance_type = "t2.micro"
  key_name	= aws_key_pair.terraform-remote.key_name
}

# Collect all information about new instance
output "microdebian1_info" {
  description	= "New instance data"
  value = aws_instance.microdebian1
}

/*
# Create elastic IP for this instance (white ip)
resource "aws_eip" "ip_microdebian1" {
  vpc		= true
  instance 	= aws_instance.microdebian1.id
}
*/

