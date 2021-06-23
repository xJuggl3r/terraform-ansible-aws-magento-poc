    #!/bin/bash

    # Installs Ansible
    sudo yum-config-manager --enable epel
    sudo yum install ansible -y

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
    ansible-vault encrypt /tmp/ansible-magento2/group_vars/all.yml
    ansible-vault encrypt /tmp/ansible-magento2/.magkey
    ansible-vault encrypt /tmp/ansible-magento2/.magsecret

    # Runs playbook
    ansible-playbook -i hosts.yml ansible-magento2.yml -vvv --become

    # Deletes .vault_pass and other files in /tmp
    sudo rm .vault_pass /tmp/sitename.txt /tmp/public_ip.txt /tmp/ansible_magento.sh /tmp/terraform_*
    sudo rm -r /tmp/ansible-magento2

    # Reboots instance to clear enviroment variables
    sudo reboot