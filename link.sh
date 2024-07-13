#!/bin/bash

echo "Establishing symbolic links..."
ln -sd $(pwd)/.config/nvim ~/.config/nvim
ln -s $(pwd)/.bashrc ~/.bashrc
ln -sd $(pwd)/.config/i3 ~/.config/i3
ln -sd $(pwd)/.config/tmux ~/.config/tmux
