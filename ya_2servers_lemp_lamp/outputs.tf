/*
output "my_lemp_subnet_data" {
  description = "Вывести на экран параметры созданной подсети LEMP"
  value = {
  "Date the LEMP subnet was created: " : yandex_vpc_subnet.lemp_servers-network.created_at,
  "Zone: " : yandex_vpc_subnet.lemp_servers-network.zone, "Name: " : yandex_vpc_subnet.lemp_servers-network.name,
  "Subnet blocks: " : yandex_vpc_subnet.lemp_servers-network.v4_cidr_blocks
  }
}

output "my_lamp_subnet_data" {
  description = "Вывести на экран параметры созданной подсети LAMP"
  value = {
  "Date the LAMP subnet was created: " : yandex_vpc_subnet.lamp_servers-network.created_at,
  "Zone: " : yandex_vpc_subnet.lamp_servers-network.zone, "Name: " : yandex_vpc_subnet.lamp_servers-network.name,
  "Subnet blocks: " : yandex_vpc_subnet.lamp_servers-network.v4_cidr_blocks
  }
}

output "lemp_instance_data" {
  description = "Вывести на экран параметры созданной виртуальной машины LEMP"
  value = {
  "Date the LEMP VM was created: " : yandex_compute_instance.lemp-srv.created_at,
  "Hostname: " : yandex_compute_instance.lemp-srv.hostname,
  "Public IP address: " : yandex_compute_instance.lemp-srv.network_interface[0].nat_ip_address,
  "Private IP address: " : yandex_compute_instance.lemp-srv.network_interface[0].ip_address
  }
}

output "lamp_instance_data" {
  description = "Вывести на экран параметры созданной виртуальной машины LAMP"
  value = {
  "Date the LAMP VM was created: " : yandex_compute_instance.lamp-srv.created_at,
  "Hostname: " : yandex_compute_instance.lamp-srv.hostname,
  "Public IP address: " : yandex_compute_instance.lamp-srv.network_interface[0].nat_ip_address,
  "Private IP address: " : yandex_compute_instance.lamp-srv.network_interface[0].ip_address
  }
}

*/