# don't anything if doesn't ubuntu
$RELEASE_FILE= /etc/os-release
if grep -e '^NAME="Ubuntu' $RELEASE_FILE >/dev/null; then
    exit 0
fi

sudo apt -y update && sudo apt -y upgrade
sudo apt -y install zsh, git
