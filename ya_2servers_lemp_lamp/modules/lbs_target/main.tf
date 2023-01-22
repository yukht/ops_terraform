/*
resource "yandex_lb_target_group" "lbs_target" {
#  region_id = "ru-central1"             # Default for Yandex (Moscow and Moscow Region)
  name      = var.target_name
#  target    = var.target_white_address

  target {
    subnet_id = var.target_white_address[0]
    address   = var.target_white_address[1]
  }
*/

/*
  target {
    subnet_id = "${yandex_vpc_subnet.my-subnet.id}"
    address   = "${yandex_compute_instance.my-instance-1.network_interface.0.ip_address}"
  }

  target {
    subnet_id = "${yandex_vpc_subnet.my-subnet.id}"
    address   = "${yandex_compute_instance.my-instance-2.network_interface.0.ip_address}"
  }
*/
}

