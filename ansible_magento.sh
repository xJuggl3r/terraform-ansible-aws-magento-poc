#!/bin/bash

GREEN="\e[32m"
ENDCOLOR="\e[0m"

# Installs Ansible
echo -e "${GREEN}====== Installing Ansible ====== ${ENDCOLOR}"
sudo yum-config-manager --enable epel
sudo yum install ansible -y

echo -e "${GREEN}====== Preparing Vault and making some magic ======${ENDCOLOR}"
# Prepares Vault
export ANSIBLE_VAULT_PASSWORD_FILE=/tmp/ansible-magento2/.vault_pass

# Decrypt /group_vars/all.yml so it can be properly edited
cd /tmp/ansible-magento2
ansible-vault decrypt /tmp/ansible-magento2/group_vars/all.yml

# Edits /group_vars/all.yml and replace magento_domain, host
read ip < /tmp/public_ip.txt
read my_domain < /tmp/sitename.txt
sudo sed -i "s/your-domain/$my_domain/g" /tmp/ansible-magento2/group_vars/all.yml
sudo sed -i "s/your-hostname/$ip/g" /tmp/ansible-magento2/group_vars/all.yml


# Replace Magento Keys
#TODO
ansible-vault decrypt /tmp/ansible-magento2/.magkey
ansible-vault decrypt /tmp/ansible-magento2/.magsecret
read magento_key < /tmp/ansible-magento2/.magkey
read magento_secret < /tmp//ansible-magento2/.magsecret
sudo sed -i "s/mag-key/$magento_key/g" /tmp/ansible-magento2/group_vars/all.yml
sudo sed -i "s/mag-secret/$magento_secret/g" /tmp/ansible-magento2/group_vars/all.yml

# Encrypts back all.yml and mag so it can be pushed safely to a repo
echo -e "${GREEN} ====== More Magic ====== ${ENDCOLOR}"
ansible-vault encrypt /tmp/ansible-magento2/group_vars/all.yml
ansible-vault encrypt /tmp/ansible-magento2/.magkey
ansible-vault encrypt /tmp/ansible-magento2/.magsecret

echo -e "${GREEN} ====== Ansible will play your book now ====== ${ENDCOLOR}"
# Runs playbook
ansible-playbook -i hosts.yml ansible-magento2.yml -vvv --become

# echo -e "${GREEN} ====== HTTPS party time ====== ${ENDCOLOR}"
# # Decrypts certs and moves them to right place
# ansible-vault decrypt /tmp/localhost.crt /tmp/localhost.key /tmp/ca-bundle.crt
# sudo chmod 600 /tmp/localhost.crt /tmp/localhost.key /tmp/ca-bundle.crt
# sudo cp /tmp/localhost.crt /etc/pki/tls/certs/localhost.crt
# sudo cp /tmp/localhost.key /etc/pki/tls/private/localhost.key
# sudo cp /tmp/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt
# sudo sed -i "s/#SSLCACertificateFile/SSLCACertificateFile/g" /etc/httpd/conf.d/ssl.conf
# sudo sed -i "s/#ServerName/ServerName/g" /etc/httpd/conf.d/ssl.conf
# sudo sed -i "s/www.example.com/anr4x4.com.br/g" /etc/httpd/conf.d/ssl.conf

# sudo cp /tmp/ca-bundle.crt /etc/pki/tls/certs/ca-bundle-client.crt
# sudo cp /tmp/ca-bundle.crt /etc/pki/tls/certs/anr4x4_com_br.crt

echo -e "${GREEN} ====== Die, Apache! May your soul rise again! ${ENDCOLOR}"
# Restarts Apache
sudo service httpd restart

echo -e "${GREEN} ====== Cleaning up the dust ====== ${ENDCOLOR}"
# Deletes .vault_pass and other files in /tmp
sudo rm .vault_pass /tmp/sitename.txt /tmp/public_ip.txt /tmp/ansible_magento.sh /tmp/terraform_* /tmp/localhost.crt /tmp/localhost.key /tmp/ca-bundle.crt
sudo rm -r /tmp/ansible-magento2

echo -e "${GREEN} ====== The resurrection ====== ${ENDCOLOR}"
# Reboots instance to clear enviroment variables
sudo reboot