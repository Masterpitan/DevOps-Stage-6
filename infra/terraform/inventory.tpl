[servers]
app-server ansible_host=${server_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[servers:vars]
domain=${domain}