variable "provider_settings" {
  # Variable settings see in credentials.auto.tfvars
  description = "provider settings"
  type        = map(string)
}

variable "network_description" {
  type    = string
}
variable "network_name" {
  type    = string
}
variable "network_id" {
  type    = string
}
variable "folder_id" {
  type    = string
}
variable "network_zone" {
  type    = string
}
variable "network_v4_cidr_blocks" {
  type    = list
}
