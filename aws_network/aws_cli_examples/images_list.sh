# aws ec2 describe-images --owners 099720109477	# Canonical
# aws ec2 describe-images --filters Name=description,Values=Canonical* --filters Name=name,Values=*ubuntu-minimal/images/*22.04*
aws ec2 describe-images --filters Name=description,Values=Canonical* --filters Name=name,Values=*ubuntu/images/*22.04*

