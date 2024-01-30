FROM ubuntu:22.04

RUN apt update && \
    apt upgrade -y && \
    apt install tmux -y && \
    apt install git -y && \
    apt install neovim -y

COPY updateItemService.ts updateItemService.ts

CMD [ "/bin/bash" ]