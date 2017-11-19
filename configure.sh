#!/bin/bash

CONF_REPO=$(pwd)
BACKUP="$CONF_REPO/backup"
c_GREEN=$(tput setaf 2)
c_NULL=$(tput sgr0)

mkdir -p backup

configure_nvim() {
    NVIM_CONF=$HOME/.config/nvim

    if [ ! -e "$NVIM_CONF/init.vim" ]; then
        ln -s "$CONF_REPO/init.vim" "$NVIM_CONF/init.vim"
    else
        echo "Configuration file init.vim already exists, I'm keeping it."
        echo "If you want to continue, delete ~/.config/nvim/init.vim"
        exit
    fi

    if ! python -c 'import neovim' 2>/dev/null; then
        echo "You need to install neovim python package."
        echo "Run pip install neovim"
        exit
    fi

    mkdir -p $NVIM_CONF

    # Install vim-plug
    echo -n "Downloading vim-plug ... "
    curl --silent -fLo $NVIM_CONF/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "DONE"

    mkdir -p "$NVIM_CONF/plugged"

    echo "Installing NeoVim plugins ... "
    nvim +PlugUpgrade +PlugInstall +qall
    echo "DONE"
}

clean_dircolors() {
    rm -f "$HOME/.dircolors"
    mv "$BACKUP/.dircolors" "$HOME/" 2>/dev/null
}
configure_dircolors() {
    FAIL="clean_dircolors"
    [ -e "$HOME/.dircolors" ] && mv "$HOME/.dircolors" "$BACKUP/"
    curl --silent -fLo $HOME/.dircolors \
        https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark    || $FAIL
}

clean_xfce4_terminal() {
    RC_DIR="$HOME/.config/xfce4/terminal"
    [ -e "$BACKUP/terminalrc" ] && mv "$BACKUP/terminalrc" "$RC_DIR/" 2>/dev/null
}
configure_xfce4_terminal() {
    tmp_file=$(mktemp)
    RC_DIR="$HOME/.config/xfce4/terminal"

    [ -e "$RC_DIR/terminalrc" ] && cp "$RC_DIR/terminalrc" "$BACKUP/"

    grep -v ^Color < "$RC_DIR/terminalrc" > $tmp_file \
    &&  curl -fL --silent \
        https://raw.githubusercontent.com/altercation/solarized/master/xfce4-terminal/dark/terminalrc \
        | grep -v '^[Configuration]' >> $tmp_file \
    && mv $tmp_file "$RC_DIR/terminalrc" \
    || rm -f $tmp_file && clean_xfce4_terminal
}

configure_git() {
    echo "[include]" >> $HOME/.gitconfig
    echo "    path=$CONF_REPO/gitconfig" >> $HOME/.gitconfig
}

clean_fonts() {
    rm -f "$HOME/.fonts/PowerlineSymbols.otf"
    rm -f "$HOME/.config/fontconfig/conf.d/10-powerline-symbols.conf"
    fc-cache -vf ~/.fonts/ &>/dev/null
    rmdir "$HOME/.fonts" 2>/dev/null
    rmdir "$HOME/.config/fontconfig/conf.d" 2>/dev/null
}
install_fonts() {
    echo -n "Creating directories ... " \
    && mkdir -p "$HOME/.fonts" \
    && mkdir -p "$HOME/.config/fontconfig/conf.d" \
    && echo "${c_GREEN}OK${c_NULL}" \
    \
    && echo -n "Downloading font files ... " \
    && wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf \
            -O "$HOME/.fonts/PowerlineSymbols.otf" -q \
    && wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf \
            -O "$HOME/.config/fontconfig/conf.d/10-powerline-symbols.conf" -q \
    && echo "${c_GREEN}OK${c_NULL}" \
    && echo -n "Regenerating font cache ... " \
    && fc-cache -vf ~/.fonts/ &>/dev/null \
    && echo "${c_GREEN}OK${c_NULL}" \
    \
    && echo \
    && echo "Powerline fonts has been installed on your system. You need" \
    && echo "to restart the application for this change to take effect." \
    && echo "If you still don't see what you expect, try deleting" \
    && echo "symbolic link /etc/fonts/conf.d/70-no-bitmaps.conf" \
    || clean_fonts
}

$@
