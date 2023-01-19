variable "current_network" {
  type    = string
}
variable "current_subnet" {
  type    = string
}

data "yandex_vpc_network" "my_primary_vpc_network" {
  network_id = var.current_network
}

data "yandex_vpc_subnet" "my_subnet_data" {
  subnet_id = var.current_subnet
}

output "my_current_subnet_data" {
  description = "Взять переменную current_subnet и вывести на экран ее параметры"
  #value = [data.yandex_vpc_subnet.my_subnet_data.created_at, data.yandex_vpc_subnet.my_subnet_data.zone, data.yandex_vpc_subnet.my_subnet_data.name]
  value = { "Date the current subnet was created: " : data.yandex_vpc_subnet.my_subnet_data.created_at, "Zone: " : data.yandex_vpc_subnet.my_subnet_data.zone, "Name: " : data.yandex_vpc_subnet.my_subnet_data.name, "Subnet blocks: " : data.yandex_vpc_subnet.my_subnet_data.v4_cidr_blocks }
}

resource "yandex_vpc_subnet" "test" {
  description = "Создание тестовой подсети"
  # Для примера возьмем значение id из data-ресурса my_primary_vpc_network
  network_id = data.yandex_vpc_network.my_primary_vpc_network.network_id
  # Зону можно взять из data, т.к. в этом примере она уже вызывалась и совпадает с требуемой зоной ru-central1-a для создания новой подсети
  zone      = data.yandex_vpc_subnet.my_subnet_data.zone
  folder_id = var.my_provider["folder"]
  name      = "work-vm-testnet"
  # Сеть 10.128.3.32/27 следующая после существующей 10.128.3.0/27
  v4_cidr_blocks = ["10.128.3.32/27"]
}

output "my_new_subnet_data" {
  description = "Вывести на экран параметры созданной подсети"
  #value = [yandex_vpc_subnet.test.created_at, yandex_vpc_subnet.test.zone, yandex_vpc_subnet.test.name]
  value = { "Date the new subnet was created: " : yandex_vpc_subnet.test.created_at, "Zone: " : yandex_vpc_subnet.test.zone, "Name: " : yandex_vpc_subnet.test.name, "Subnet blocks: " : yandex_vpc_subnet.test.v4_cidr_blocks }
}


# CREATE NETWORK (Doesn't work because the limit has been reached) #
/*
  resource "yandex_vpc_network" "test" {
  description = "Создание тестовой сети"
  }
#
output "o_new_test_network" {
  #value = [yandex_vpc_network.test.id, yandex_vpc_network.test.created_at]
  value = {"id: ":yandex_vpc_network.test.id, "date: ":yandex_vpc_network.test.created_at, "description": yandex_vpc_network.test.description}
}
*/

