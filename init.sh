sudo apt -y update
sudo apt -y install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt -y install ansible
ansible-playbook -i localhost, -c local playbook.yml

