#!/bin/bash
echo "Updating package list..."
apt update

echo "Upgrading packages..."
apt upgrade -y

# replacement for cat
echo "Installing bat..."
apt install bat -y

# replacement for ls
echo "Installing eza..."
wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
chmod +x eza
chown root:root eza
mv eza /usr/local/bin/eza

# tools for building and compiling binaries
echo "Installing build essentials..."
apt install build-essential -y

# tool for managing displays/monitors
echo "Installing x11-xserver-utils..."
apt install x11-xserver-utils -y

# C and C++ compiler
apt install clang -y

# HTTP requests
echo "Installing curl..."
apt install curl -y

# version control
echo "Installing git..."
apt install git -y

# terminal multiplexer
echo "Installing tmux..."
apt install tmux -y

echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# search tool using regex patterns
echo "Installing ripgrep..."
apt install ripgrep -y

# command line fuzzy finder
echo "Installing fzf..."
apt install fzf -y

# alternative to find
echo "Installing fd-find..."
apt install fd-find

# command line JSON processor
echo "Installing jq..."
apt install jq -y

echo "Installing python..."
apt install python3 -y
apt install python3.10-venv -y

# required for working with C# and C++
echo "Installing dotnet sdk..."
apt install dotnet-sdk-8.0 -y

# required for working with C# and C++
echo "Installing aspnetcore runtime..."
apt install aspnetcore-runtime-8.0 -y

# required for working with C# and C++
echo "Installing dotnet runtime..."
apt install dotnet-runtime-8.0 -y

echo "Installing mono runtime..."
apt install ca-certificates gnupg -y
gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
apt update
apt install mono-devel -y

echo "Installing nodejs..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# git CLI
echo "Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin

# docker CLI
echo "Installing lazydocker..."
brew install jesseduffield/lazydocker/lazydocker

# text editor + IDE
echo "Installing neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
mv squashfs-root /
rm -rf /usr/bin/nvim
ln -s /squashfs-root/AppRun /usr/bin/nvim

# package manager
echo "Installing homebrew..."
yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "Installing gcc..."
brew install gcc

# file content comparison tool
echo "Installing difftastic..."
brew install difftastic

# command line JSON viewer
echo "Installing jless..."
brew install jless

# terminal file manager
echo "Installing yazi..."
brew install yazi ffmpegthumbnailer unar poppler fd
brew tap homebrew/cask-fonts && brew install --cask font-symbols-only-nerd-font

# replacement for cd
echo "Installing zoxide..."
brew install zoxide

echo "Installing netcoredbg..."
cp -r netcoredbg /usr/local/bin/
chmod 777 /usr/local/bin/netcoredbg/*

# tool for taking screenshots of code
echo "Installing silicon..."
apt install expat -y
apt install libxml2-dev -y
apt install pkg-config libasound2-dev libssl-dev cmake libfreetype6-dev libexpat1-dev libxcb-composite0-dev libharfbuzz-dev -y
brew install silicon

echo "Installing JetBrains fonts..."
apt install fonts-jetbrains-mono

# window manager
echo "Installing i3..."
apt install i3 -y

echo "Installing docker..."
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
	apt update
	apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
groupadd docker
usermod -aG docker $USER

# resource monitor
echo "Installing btop..."
sh ./btop/install.sh
sh ./btop/setuid.sh

echo "Establishing symbolic links..."
ln -sd $(pwd)/.config/nvim ~/.config/nvim
ln -s $(pwd)/.bashrc ~/.bashrc
ln -sd $(pwd)/.config/i3 ~/.config/i3
ln -sd $(pwd)/.config/tmux ~/.config/tmux

echo "Performing clean up..."
yes | rm lazygit lazygit.tar.gz nvim.appimage 
rm -rf squashfs-root/
