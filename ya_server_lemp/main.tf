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
  value = { "Date the current subnet was created: " : data.yandex_vpc_subnet.my_subnet_data.created_at, "Zone: " : data.yandex_vpc_subnet.my_subnet_data.zone, "Name: " : data.yandex_vpc_subnet.my_subnet_data.name, "Subnet blocks: " : data.yandex_vpc_subnet.my_subnet_data.v4_cidr_blocks }
}

# Создать сеть для тестовых серверов в директории тестовых стендов
resource "yandex_vpc_subnet" "test-servers-network" {
  description = "Создание подсети для тестовых серверов"
  network_id = var.current_network
/*
# Зону можно взять из data-ресурса, т.к для создания новой подсети будет использована зона ru-central1-a,
* совпадающая с current_subnet (data-ресурс my_subnet_data)
*/
  zone      = data.yandex_vpc_subnet.my_subnet_data.zone
  folder_id = var.my_provider["folder"]
  name      = "test-servers-network"
  v4_cidr_blocks = ["10.128.1.0/27"]
}

output "my_new_subnet_data" {
  description = "Вывести на экран параметры созданной подсети"
  value = { "Date the new subnet was created: " : yandex_vpc_subnet.test-servers-network.created_at, "Zone: " : yandex_vpc_subnet.test-servers-network.zone, "Name: " : yandex_vpc_subnet.test-servers-network.name, "Subnet blocks: " : yandex_vpc_subnet.test-servers-network.v4_cidr_blocks }
}

# Генерировать ssh-ключи
resource "tls_private_key" "ssh_key_lemp_srv" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" { # Сохранить приватный ключ в текущую директорию
    command = "echo '${tls_private_key.ssh_key_lemp_srv.private_key_pem}' > ./ssh_key_lemp_srv.pem && chmod 600 ./ssh_key_lemp_srv.pem"
  }

}

# Создание виртуальной машины LEMP (Linux Nginx MySQL PHP)
data "yandex_compute_image" "lemp_srv_image_data" {
  family = "lemp"
}
resource "yandex_compute_instance" "lemp-srv" {
  name        = "lemp-srv"
  zone        = yandex_vpc_subnet.test-servers-network.zone
  hostname = "lemp-srv"
  platform_id = "standard-v3"   # для 50% core_fraction

  resources {
    cores  = 2
    core_fraction = "50"
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.lemp_srv_image_data.image_id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.test-servers-network.id}"
    ip_address = "10.128.1.10"
    nat = "true"
  }

  metadata = {
#    ssh-keys = "ubuntu:${file("./ssh_key_lemp_srv.pub")}"
    ssh-keys = "ubuntu:${tls_private_key.ssh_key_lemp_srv.public_key_openssh}"
    }
}

output "my_new_instance_data" {
  description = "Вывести на экран параметры созданной виртуальной машины"
  value = { "Date the new VM was created: " : yandex_compute_instance.lemp-srv.created_at,
  "Hostname: " : yandex_compute_instance.lemp-srv.hostname, "Public IP address: " : yandex_compute_instance.lemp-srv.network_interface[0].nat_ip_address }
}

/*
# Через output можно посмотреть все параметры образа yandex_compute_image до создания ВМ
output "test" {
  value = data.yandex_compute_image.lemp_srv_image_data
}
*/

