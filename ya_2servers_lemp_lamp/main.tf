variable "my_network" {
  # Variable settings see in credentials.auto.tfvars
  description = "network settings"
  type        = map(string)
}

module "network_lemp" {
  source  = "./modules/network"
  network_description     = "Создание подсети для серверов lemp"
  network_name            = "lemp-servers-subnet"
  network_id              = var.my_network["current_network"]       # from credentials.auto.tfvars
  folder_id               = var.my_provider["folder"]               # from credentials.auto.tfvars
  network_zone            = var.my_network["zone_a"]                # from networks.auto.tfvars
  network_v4_cidr_blocks  = ["10.128.1.0/27"]
}

module "network_lamp" {
  source  = "./modules/network"
  network_description     = "Создание подсети для серверов lamp"
  network_name            = "lamp-servers-subnet"
  network_id              = var.my_network["current_network"]       # from credentials.auto.tfvars
  folder_id               = var.my_provider["folder"]               # from credentials.auto.tfvars
  network_zone            = var.my_network["zone_b"]                # from networks.auto.tfvars
  network_v4_cidr_blocks  = ["10.129.1.0/27"]
}

module "srv_lemp" {
  source  = "./modules/srv"
  srv_family              = "lemp"
  srv_name                = "lemp-srv"
  srv_description         = "VM LEMP (Linux Nginx MySQL PHP)"
  srv_zone                = var.my_network["zone_a"]                # from networks.auto.tfvars
  srv_cores               = 2
  srv_memory              = 2
  srv_subnet              = module.network_lemp.created_id
  srv_ip                  = "10.128.1.10"
}

module "srv_lamp" {
  source  = "./modules/srv"
  srv_family              = "lamp"
  srv_name                = "lamp-srv"
  srv_description         = "VM LAMP (Linux Apache MySQL PHP)"
  srv_zone                = var.my_network["zone_b"]                # from networks.auto.tfvars
  srv_cores               = 2
  srv_memory              = 2
  srv_subnet              = module.network_lamp.created_id
  srv_ip                  = "10.129.1.10"
}

