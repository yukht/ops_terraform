output "srv_info" {
  description = "Information about created VM, which can be viewed after creation"
  value = [
    module.srv_lemp.srv_instance_data,
    module.srv_lamp.srv_instance_data
    ]
}
