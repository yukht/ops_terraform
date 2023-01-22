/*
output "srv_instance_data" {
  description = "The parameters of the created virtual machine for use by external modules"
  value = {
  "Date_of_created" : yandex_compute_instance.srv.created_at,
  "Hostname" : yandex_compute_instance.srv.hostname,
  "Public_address" : yandex_compute_instance.srv.network_interface[0].nat_ip_address,
  "Private_address" : yandex_compute_instance.srv.network_interface[0].ip_address
  }
}
*/