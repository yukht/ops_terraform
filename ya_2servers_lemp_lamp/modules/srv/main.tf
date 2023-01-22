# Генерировать ssh-ключи
resource "tls_private_key" "ssh_key_srv" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" { # Сохранить приватный ключ в текущую директорию
    command = "echo '${tls_private_key.ssh_key_srv.private_key_pem}' > ./${var.srv_name}-ssh_key.pem && chmod 600 ./${var.srv_name}-ssh_key.pem"
  }

}

# Creating a virtual machine
data "yandex_compute_image" "srv_image_data" {
  family = var.srv_family
}
resource "yandex_compute_instance" "srv" {
  name        = var.srv_name
  description = var.srv_description
  zone        = var.srv_zone
  hostname    = var.srv_name
  platform_id = "standard-v3"   # for use 50% core_fraction

  resources {
    cores  = var.srv_cores
    core_fraction = "50"
    memory = var.srv_memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.srv_image_data.image_id
    }
  }

  network_interface {
    subnet_id = var.srv_subnet                  # This example implies a network created by the network module
    ip_address = var.srv_ip
    nat = "true"                                # To create a balancer, an external address is needed
  }

  metadata = {
    ssh-keys = "admin:${tls_private_key.ssh_key_srv.public_key_openssh}"
    }
}

