#!/bin/sh

conf_dir=$(pwd)

if [ ! -e "$HOME/.config/nvim/init.vim" ]; then
    ln -s "$conf_dir/init.vim" "$HOME/.config/nvim/init.vim"
else
    cat <<EOF
Configuration file init.vim already exists, I'm keeping it.
If you want to continue, delete ~/.config/nvim/init.vim
EOF
    exit
fi

mkdir -p $HOME/.config/nvim/bundle
cd $HOME/.config/nvim/bundle

if [ ! -d "Vundle.vim" ]; then
    git clone https://github.com/gmarik/Vundle.vim.git
fi

cat <<EOF
Configuration almost complete. Run following commands:

pip install neovim
nvim +PluginInstall +q
EOF
