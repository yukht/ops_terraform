Host ${public_ip}
	IdentityFile ~/.ssh/vm_all-ssh_key_ansible.pem
	HostName ${public_ip}
	User root
	Port 22
