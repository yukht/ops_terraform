variable v_access_key_provider {
  type = string
  sensitive = true
}
variable v_secret_key_provider {
  type = string
  sensitive = true
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.50.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.v_access_key_provider
  secret_key = var.v_secret_key_provider
}


