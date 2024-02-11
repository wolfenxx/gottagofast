#!/bin/bash
echo "Updating package list..."
apt update

echo "Upgrading packages..."
apt upgrade -y

echo "Installing build essentials..."
apt install build-essential -y

echo "Installing curl..."
apt install curl -y

echo "Installing git..."
apt install git -y

echo "Installing tmux..."
apt install tmux -y

echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Installing python..."
apt install python3 -y

echo "Installing nodejs..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo "Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin

echo "Installing neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract

if [ "$IS_DOCKER" != "true"]; then
echo “Moving squashfs-root to root directory...”
mv squashfs-root /

echo "Removing existing nvim directory..."
rm -rf /usr/bin/nvim

echo "Installing i3..."
apt install i3 -y
fi

echo "Setting symlink to neovim..."
ln -s /squashfs-root/AppRun /usr/bin/nvim
