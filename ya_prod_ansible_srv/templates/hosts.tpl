[all:vars]
ansible_connection=ssh
ansible_user=${tplt_hosts_username}
ansible_ssh_private_key_file=${tplt_hosts_key_path}

# ansible_clients
[ansible1]
${tplt_hosts_address}
#10.128.1.11

[ansible1:vars]
my_public_address=${tplt_hosts_public_address}
