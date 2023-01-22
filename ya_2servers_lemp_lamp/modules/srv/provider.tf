terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.84.0"
    }
  }
}
provider "yandex" {
  service_account_key_file = file("ya_key.json")
  cloud_id                 = var.provider_settings["cloud"]
  folder_id                = var.provider_settings["folder"]
  zone                     = var.provider_settings["zone"]  # default zone
}

