sudo apt -y update
sudo apt -y install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo add-apt-repository --yes --update ppa:longsleep/golang-backports
sudo apt -y install ansible
ansible-playbook -i localhost, -c local playbook.yml
fish -c "fisher add jethrokuan/z" && fish -c "fisher add decors/fish-ghq" && fish -c "fisher add oh-my-fish/theme-bobthefish"
