#!/bin/bash

# Installs Ansible
sudo yum-config-manager --enable epel
sudo yum install ansible -y

# Prepares Vault
export ANSIBLE_VAULT_PASSWORD_FILE=/tmp/ansible-magento2/.vault_pass

# Decrypt /group_vars/all.yml so it can be properly edited
cd /tmp/ansible-magento2
ansible-vault decrypt /tmp/ansible-magento2/group_vars/all.yml

# Edits /group_vars/all.yml and replace ip, host
read ip < /tmp/public_ip.txt
read my_domain < /tmp/sitename.txt
sudo sed -i "s/your-domain/$my_domain/g" /tmp/ansible-magento2/group_vars/all.yml
sudo sed -i "s/3.237.236.99/$ip/g" /tmp/ansible-magento2/group_vars/all.yml

# Replace Magento Keys
#TODO

# Encrypts back all.yml so it can be pushed safely to a repo
ansible-vault encrypt /tmp/ansible-magento2/group_vars/all.yml

# Runs playbook
ansible-playbook -i hosts.yml ansible-magento2.yml -vvv --become

# Deletes .vault_pass
sudo rm .vault_pass

# Reboots instance to clear enviroment variables
sudo reboot