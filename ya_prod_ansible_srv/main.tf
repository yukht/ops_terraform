variable "my_network" {
  # Variable settings see in credentials.auto.tfvars
  description = "network settings"
  type        = map(string)
}

module "network_ansible" {
  source                 = "./modules/network"
  network_description    = "Создание подсети для клиентов ansible"
  network_name           = "ansible-servers-subnet"
  network_id             = var.my_network["current_network"] # from credentials.auto.tfvars
  folder_id              = var.my_provider["folder"]         # from credentials.auto.tfvars
  network_zone           = var.my_network["zone_a"]          # from networks.auto.tfvars
  network_v4_cidr_blocks = ["10.128.1.0/27"]
}


module "key_vm_all_automation" {
  source        = "./modules/keys"
  key_srv_name  = "vm_all"
  key_user_name = "ansible"
}

/*

# Notice! This example REQUIRES the creation of two users for each new machine. This need is caused by the 'srv' module code! #
 module "key_vm1_default" {
   source  = "./modules/keys"
     key_srv_name            = "vm1"
       key_user_name           = "admin"
       #  key_pub_key_save        = "true"
       }


module "vm1" {
  source  = "./modules/srv"
  srv_family              = "ubuntu-2004-lts"                                   # also 'ubuntu-2204-lts' is latest stable v22.04
  srv_default_user        = "admin"                                             # default ssh user
  srv_second_user         = "ansible"                                           # second ssh user for automation
  srv_key1                = module.key_vm1_default.ssh_key_v                    # default ssh user public key
  srv_key2                = module.key_vm_all_automation.ssh_key_v              # second ssh user public key
  srv_name                = "vm1"
  srv_description         = "vm1 database"
  srv_zone                = var.my_network["zone_a"]                            # from networks.auto.tfvars
# use standard-v3 for 50% core_fraction and standard-v1 (Intel Broadwell) for minumim server price (with 20% core_fraction) #
  srv_platform_id         = "standard-v1"
  srv_core_fraction       = "20"
  srv_cores               = 2
  srv_memory              = 2
  srv_disk_size           = 20                                                  # Size of the disk in GB
  srv_subnet              = module.network_ansible.created_id
  srv_ip                  = "10.128.1.10"
  srv_nat                 = "false"                                             # If you create a balancer, an external address is needed!
}

# save public ip to file (TODO: replace to template)
resource "local_file" "srv1_public_ip" {
  content = module.vm1.public_address
  filename = "server_data/vm1_public_ip"
}

# save private ip to file (TODO: replace to template)
resource "local_file" "srv1_private_ip" {
  content = module.vm1.private_address
  filename = "server_data/vm1_private_ip"
}



module "key_vm2_default" {
  source  = "./modules/keys"
  key_srv_name            = "vm2"
  key_user_name           = "admin"
}

module "vm2" {
  source  = "./modules/srv"
  srv_family              = "ubuntu-2004-lts"                                   # also 'ubuntu-2204-lts' is latest stable v22.04
  srv_default_user        = "admin"                                             # default ssh user
  srv_second_user         = "ansible"                                           # second ssh user for automation
  srv_key1                = module.key_vm2_default.ssh_key_v                    # default ssh user public key
  srv_key2                = module.key_vm_all_automation.ssh_key_v              # second ssh user public key
  srv_name                = "vm2"
  srv_description         = "vm2 app"
  srv_zone                = var.my_network["zone_a"]                            # from networks.auto.tfvars
# use standard-v3 for 50% core_fraction and standard-v1 (Intel Broadwell) for minumim server price (with 20% core_fraction) #
  srv_platform_id         = "standard-v1"
  srv_core_fraction       = "20"
  srv_cores               = 2
  srv_memory              = 2
  srv_disk_size           = 20                                                  # Size of the disk in GB
  srv_subnet              = module.network_ansible.created_id
  srv_ip                  = "10.128.1.11"
  srv_nat                 = "false"                                             # If you create a balancer, an external address is needed!
}

# save public ip to file (TODO: replace to template)
resource "local_file" "srv2_public_ip" {
  content = module.vm2.public_address
  filename = "server_data/vm2_public_ip"
}

# save private ip to file (TODO: replace to template)
resource "local_file" "srv2_private_ip" {
  content = module.vm2.private_address
  filename = "server_data/vm2_private_ip"
}


module "key_vm3_default" {
  source  = "./modules/keys"
  key_srv_name            = "vm3"
  key_user_name           = "admin"
}

module "vm3" {
  source  = "./modules/srv"
  srv_family              = "centos-stream-8"                                   # also 'centos-7' is stable Centos v7
  srv_default_user        = "admin"                                             # default ssh user
  srv_second_user         = "ansible"                                           # second ssh user for automation
  srv_key1                = module.key_vm3_default.ssh_key_v                    # default ssh user public key
  srv_key2                = module.key_vm_all_automation.ssh_key_v              # second ssh user public key
  srv_name                = "vm3"
  srv_description         = "vm3 app"
  srv_zone                = var.my_network["zone_a"]                            # from networks.auto.tfvars
# use standard-v3 for 50% core_fraction and standard-v1 (Intel Broadwell) for minumim server price (with 20% core_fraction) #
  srv_platform_id         = "standard-v1"
  srv_core_fraction       = "20"
  srv_cores               = 2
  srv_memory              = 2
  srv_disk_size           = 20                                                  # Size of the disk in GB
  srv_subnet              = module.network_ansible.created_id
  srv_ip                  = "10.128.1.12"
  srv_nat                 = "false"                                             # If you create a balancer, an external address is needed!
}

# save public ip to file (TODO: replace to template)
resource "local_file" "srv3_public_ip" {
  content = module.vm3.public_address
  filename = "server_data/vm3_public_ip"
}

# save private ip to file (TODO: replace to template)
resource "local_file" "srv3_private_ip" {
  content = module.vm3.private_address
  filename = "server_data/vm3_private_ip"
}
*/


# TEMPORARY VM1 minimal for docker (active)

module "key_vm1_default" {
  source        = "./modules/keys"
  key_srv_name  = "vm1"
  key_user_name = "admin"
}


module "vm1" {
  source           = "./modules/srv"
  srv_family       = "ubuntu-2204-lts"                      #
  srv_default_user = "admin"                                # default ssh user
  srv_second_user  = "ansible"                              # second ssh user for automation
  srv_key1         = module.key_vm1_default.ssh_key_v       # default ssh user public key
  srv_key2         = module.key_vm_all_automation.ssh_key_v # second ssh user public key
  srv_name         = "vm1"
  srv_description  = "vm1 docker"
  srv_zone         = var.my_network["zone_a"] # from networks.auto.tfvars
  # use standard-v3 for 50% core_fraction and standard-v1 (Intel Broadwell) for minumim server price (with 20% core_fraction) #
  srv_platform_id   = "standard-v1"
  srv_core_fraction = "20"
  srv_cores         = 2
  srv_memory        = 2
  srv_disk_size     = 10 # Size of the disk in GB
  srv_subnet        = module.network_ansible.created_id
  srv_ip            = "10.128.1.10"
  srv_nat           = "true" # If you create a balancer, an external address is needed!
}

# Put template code in a separate module to call on demand
data "template_file" "ssh_config_ext" {
  template = file("${path.module}/templates/.ssh/config_ext.tpl") # local path to template 
  vars = {
    tplt_vm_name        = "vm1-docker"
    tplt_public_ip      = module.vm1.public_address
  }
}

resource "null_resource" "update_inventory" {
  triggers = { # apply next block after rendered
    template = data.template_file.ssh_config_ext.rendered
  }
  provisioner "local-exec" { # After rendered run local command 'echo'
    command = "echo '${data.template_file.ssh_config_ext.rendered}' > server_data/ssh_config_ext"
  }
}

/*
# Save public ip to file (TODO: replace to template)
resource "local_file" "srv1_public_ip" {
  content  = module.vm1.public_address
  filename = "server_data/vm1_public_ip"
}

# Save private ip to file (TODO: replace to template)
resource "local_file" "srv1_private_ip" {
  content  = module.vm1.private_address
  filename = "server_data/vm1_private_ip"
}

*/


/*
# Working balancer module (not required in this case)
# It is difficult to transfer the creation of a target group of servers to a separate module,
# because "target" blocks are required, as in the example below:
resource "yandex_lb_target_group" "lb_target" {
#  region_id = "ru-central1"             # Default for Yandex (Moscow and Moscow Region)
  name      = "target-group-web"
  target {
    subnet_id = module.srv_lemp.srv_subnet_id
#    address   = module.srv_lemp.public_address     #(doesn't work)
    address   = module.srv_lemp.private_address
  }
  target {
    subnet_id = module.srv_lamp.srv_subnet_id
#    address   = module.srv_lamp.public_address     #(doesn't work)
    address   = module.srv_lamp.private_address
  }
}

module "lb-web" {
  source = "./modules/lb"
  lb_name                 = "lb-web"
  lb_group_id             = yandex_lb_target_group.lb_target.id
#  lb_subnet_id            = module.srv_lemp.srv_subnet_id        # only for internal lb
  depends_on = [yandex_lb_target_group.lb_target]
}
*/



