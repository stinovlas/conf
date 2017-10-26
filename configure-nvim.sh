#!/bin/sh

REPO=$(pwd)
NVIM_CONF=$HOME/.config/nvim

mkdir -p $NVIM_CONF

if [ ! -e "$NVIM_CONF/init.vim" ]; then
    ln -s "$REPO/init.vim" "$NVIM_CONF/init.vim"
else
    cat <<EOF
Configuration file init.vim already exists, I'm keeping it.
If you want to continue, delete ~/.config/nvim/init.vim
EOF
    exit
fi

mkdir -p "$NVIM_CONF/bundle"
cd "$NVIM_CONF/bundle"

if [ ! -d "Vundle.vim" ]; then
    git clone https://github.com/gmarik/Vundle.vim.git
fi

cat <<EOF
Configuration almost complete. Run following commands:

pip install neovim
nvim +PluginInstall +q
EOF
