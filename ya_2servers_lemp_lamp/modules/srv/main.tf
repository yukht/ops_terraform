/*
variable "my_network" {
  # Variable settings see in credentials.auto.tfvars
  description = "network settings"
  type        = map(string)
}
*/

# Модуль для создания серверных подсетей
resource "yandex_vpc_subnet" "servers-network" {
  network_id      = var.network_id
  folder_id       = var.folder_id
  description     = var.network_description
  name            = var.network_name
  zone            = var.network_zone 
  v4_cidr_blocks  = var.network_v4_cidr_blocks
}


output "created_id" {
  value = yandex_vpc_subnet.subnet.id
}