FROM ubuntu:22.04

RUN apt update && \
    apt upgrade -y && \
    apt install curl -y && \
    apt install tmux -y && \
    apt install git -y && \
    apt install neovim -y && \
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    install lazygit /usr/local/bin

COPY updateItemService.ts updateItemService.ts

CMD [ "/bin/bash" ]
