data "template_file" "ansible_inventory" {
  template = file("${path.module}/inventory.ini.tpl") # local path to template 
  vars = {
    backend_ip  = "192.168.0.1"
    frontend_ip = "192.168.0.2"
  }
}

resource "null_resource" "update_inventory" {
  triggers = { # apply next block after rendered
    template = data.template_file.ansible_inventory.rendered
  }
  provisioner "local-exec" { # After rendered run local command 'echo'
    command = "echo '${data.template_file.ansible_inventory.rendered}' > inventory.ini"
  }
}

