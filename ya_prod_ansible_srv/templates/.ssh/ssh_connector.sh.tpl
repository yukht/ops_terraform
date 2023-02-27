ssh-keygen -f "/root/.ssh/known_hosts" -R "${tplt_public_ip}"
ssh -i ${tplt_key_path} ansible@${tplt_public_ip}
