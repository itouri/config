#!/bin/bash

packagelist=(
    "vim"
    "git"
    "wget"
    "curl"
    "tig"
    "python3"
    "golang-go"
    "peco"
    "zsh"
)

echo "--- update and upgrade ---"
sudo apt -y update
sudo apt -y upgrade

echo "--- start apt install ---"
for list in ${packagelist[@]}; do
    sudo apt -y install ${list}
done

echo "--- install vim bundle ---"
git clone https://github.com/VundleVim/Vundle.vim.git /home/$USER/.vim/bundle/Vundle.vim

echo "--- install vim bundle ---"
vim +PluginInstall +qall

echo "--- install ghq ---"
export GOPATH=/home/$USER/go
go get github.com/motemen/ghq

echo "--- install zplug ---"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

#TODO
bash ./setup.sh
