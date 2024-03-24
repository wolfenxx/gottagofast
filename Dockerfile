FROM ubuntu:22.04

COPY .config/ /root/.config/

COPY .bashrc/ /root/.bashrc

COPY netcoredbg netcoredbg

RUN sed -i -e 's/\r$//' ~/.bashrc && \
    echo "Updating package list..." && \
    apt update && \
    echo "Upgrading packages..." && \
    apt upgrade -y && \
    echo "Installing build essentials..." && \
    apt install build-essential -y && \
    echo "Installing curl..." && \
    apt install curl -y && \
    echo "Installing git..." && \
    apt install git -y && \
    echo "Installing tmux..." && \
    apt install tmux -y && \
    echo "Installing tmux plugin manager..." && \
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
    echo "Installing ripgrep..." && \
    apt install ripgrep -y && \
    echo "Installing fzf..." && \
    apt install fzf -y && \
    echo "Installing fd-find..." && \
    apt install fd-find && \
    echo "Installing jq..." && \
    apt install jq -y && \
    echo "Installing python..." && \
    apt install python3 -y && \
    apt install python3.10-venv -y && \
    echo "Installing dotnet sdk..." && \
    apt install dotnet-sdk-8.0 -y && \
    echo "Installing aspnetcore runtime..." && \
    apt install aspnetcore-runtime-8.0 -y && \
    echo "Installing dotnet runtime..." && \
    apt install dotnet-runtime-8.0 -y && \
    echo "Installing mono runtime..." && \
    apt install ca-certificates gnupg -y && \
    gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt update && \
    apt install mono-devel -y && \
    echo "Installing nodejs..." && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt install -y nodejs && \
    echo "Installing lazygit..." && \
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit /usr/local/bin && \
    echo "Installing neovim..." && \
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && \
    chmod u+x nvim.appimage && \
    ./nvim.appimage --appimage-extract && \
    echo "Setting symlink to neovim..." && \
    ln -s /squashfs-root/AppRun /usr/bin/nvim && \
    echo "Installing homebrew..." && \
    yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    echo "Installing gcc..." && \
    brew install gcc && \
    echo "Installing netcoredbg..." && \
    cp -r netcoredbg /usr/local/bin/ && \
    chmod 777 /usr/local/bin/netcoredbg/* && \
    echo "Installing silicon..." && \
    apt install expat -y && \
    apt install libxml2-dev -y && \
    apt install pkg-config libasound2-dev libssl-dev cmake libfreetype6-dev libexpat1-dev libxcb-composite0-dev libharfbuzz-dev -y && \
    brew install silicon && \
    echo "Installing JetBrains fonts..." && \
    apt install fonts-jetbrains-mono

WORKDIR /root

CMD [ "/bin/bash" ]
