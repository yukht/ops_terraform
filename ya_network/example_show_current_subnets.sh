yc vpc subnets list
read -p "Enter subnet to show info about it: " bash_subnet_id
terraform refresh -var="current_subnet=$bash_subnet_id"

