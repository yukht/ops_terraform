variable "my_network" {
  # Variable settings see in credentials.auto.tfvars
  description = "network settings"
  type        = map(string)
}

module "network_lemp" {
  source  = "./modules/network"
  network_description     = "Создание подсети для серверов lemp"
  network_name            = "lemp_servers-network"
  network_id              = var.my_network["current_network"]    # from credentials.auto.tfvars
  folder_id                = var.my_provider["folder"]            # from credentials.auto.tfvars
  network_zone            = var.my_network["zone_a"]
  network_v4_cidr_blocks  = ["10.128.1.0/27"]
  provider_settings       = var.my_provider 
}


module "network_lamp" {
  source  = "./modules/network"
  network_description     = "Создание подсети для серверов lamp"
  network_name            = "lamp_servers-network"
  network_id              = var.my_network["current_network"]    # from credentials.auto.tfvars
  folder_id               = var.my_provider["folder"]            # from credentials.auto.tfvars
  network_zone            = var.my_network["zone_b"]
  network_v4_cidr_blocks  = ["10.129.1.0/27"]
  provider_settings       = var.my_provider
}


## НЕ ЗАБЫТЬ OUTPUT ИЗ NETWORK ПЕРЕДАТЬ В НОВЫЙ МОДУЛЬ ПО СОЗДАНИЮ ИНСТАНСОВ! (КОТОРЫЙ СЕЙЧАС НИЖЕ ДУБЛИРУЕТСЯ)

### LEMP ###

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
  zone        = var.my_network["zone_a"]
  hostname    = "lemp-srv"
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
#    subnet_id = module.network.created_id
    subnet_id = module.network_lemp.created_id
    ip_address = "10.128.1.10"
    nat = "true"
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.ssh_key_lemp_srv.public_key_openssh}"
    }
}


### LAMP ###


# Генерировать ssh-ключи
resource "tls_private_key" "ssh_key_lamp_srv" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" { # Сохранить приватный ключ в текущую директорию
    command = "echo '${tls_private_key.ssh_key_lamp_srv.private_key_pem}' > ./ssh_key_lamp_srv.pem && chmod 600 ./ssh_key_lamp_srv.pem"
  }

}

# Создание виртуальной машины LAMP (Linux Apache MySQL PHP)
data "yandex_compute_image" "lamp_srv_image_data" {
  family = "lamp"
}
resource "yandex_compute_instance" "lamp-srv" {
  name        = "lamp-srv"
  zone        = var.my_network["zone_b"]
  hostname    = "lamp-srv"
  platform_id = "standard-v3"   # для 50% core_fraction

  resources {
    cores  = 2
    core_fraction = "50"
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.lamp_srv_image_data.image_id
    }
  }

  network_interface {
    subnet_id = module.network_lamp.created_id
    ip_address = "10.129.1.10"
    nat = "true"
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.ssh_key_lamp_srv.public_key_openssh}"
    }
}

