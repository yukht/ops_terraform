/*
# I have a service account, so don't need to create it and grant permissions
resource "yandex_iam_service_account" "my_sa" {
  folder_id = var.my_provider["folder"]
  name      = "tf-test-sa"
}
# Assign the role to service account
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.my_provider["folder"]
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.my_sa.id}"
}
*/
variable "my_sa" {
  # "my_sa" variable is set in credentials.auto.tfvars
  description = "My service account"
  type        = string
  sensitive    = true
}
variable "my_state_remote_path" {
  # "my_state_remote_path" variable is set in credentials.auto.tfvars
  description = "Path to save state file on a remote object storage"
  type        = string
}

variable "my_storage_region" {
  # "my_storage_region" variable is set in credentials.auto.tfvars
  description = "Remote object storage region"
  type        = string
}
variable "my_static_storage_endpoint" {
  # "my_static_storage_endpoint" variable is set in credentials.auto.tfvars
  description = "Remote object storage endpoint"
  type        = string
}

locals {
  sensitive_access_key = sensitive(yandex_iam_service_account_static_access_key.bucket-static-key.access_key)
  sensitive_secret_key = sensitive(yandex_iam_service_account_static_access_key.bucket-static-key.secret_key)
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "bucket-static-key" {
#  service_account_id = yandex_iam_service_account.my_sa.id
  service_account_id = var.my_sa
  description        = "terraform-remote-create-bucket"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "mybucket" {
#  access_key = yandex_iam_service_account_static_access_key.bucket-static-key.access_key
#  secret_key = yandex_iam_service_account_static_access_key.bucket-static-key.secret_key
  access_key = yandex_iam_service_account_static_access_key.bucket-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket-static-key.secret_key
  bucket = "tf-bucket"
  max_size = 524288000 # 500Mb
  anonymous_access_flags {
    read = true
    list = false
  }
}

/*
* WARNING! This experimental script copies your state-file on a remote storage!
* Make sure that you understand possible risks when performing this step
* This example does not provide instructions for restoring the state-file 
* If you have a problems and cannot deal with recovery yourself, contact me: yukht
*/

data "template_file" "private_bucket_vars" {
  template = file("${path.module}/private_bucket_vars.conf.tpl") # local path to template 
  vars = {
    bucket_endpoint="${var.my_static_storage_endpoint}"
    bucket_bucket="${yandex_storage_bucket.mybucket.bucket}"
    bucket_region="${var.my_storage_region}"
    bucket_key="${var.my_state_remote_path}"
    bucket_access_key="${local.sensitive_access_key}"
    bucket_secret_key="${local.sensitive_secret_key}"
  }
}

resource "null_resource" "update_private_bucket_vars" {
  triggers = { # apply next block after rendered
    template = sensitive(data.template_file.private_bucket_vars.rendered)
  }
  provisioner "local-exec" { # After rendered run local command 'echo'
    command = "echo '${data.template_file.private_bucket_vars.rendered}' > private_bucket_vars.conf"
  }
  provisioner "local-exec" { # Create .tf file with "S3" block for reinitialize terraform
    command = "cat dummy_file.tpl | sed 's/\\#//g' > prod_backend.tf"
  }  
}

# This is example from https://jhooq.com/terraform-null-resource
# The following null resource has the trigger
resource "null_resource" "tr-reinitialize" {
  
  # This trigger will only execute once when it detects id of 'yandex_storage_bucket' object 
  triggers = {
    id = yandex_storage_bucket.mybucket.id    # to execute it every time replace - id = time()
  }
  provisioner "local-exec" {
    command = "terraform init -backend-config=private_bucket_vars.conf -force-copy -lock=false"
  }
}

output "my_keys_data" {
  value = yandex_iam_service_account_static_access_key.bucket-static-key.created_at
}

output "my_storage_data" {
  value = yandex_storage_bucket.mybucket.bucket_domain_name
}
