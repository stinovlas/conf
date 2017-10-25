#!/bin/sh

echo -n "Creating directories ... "
mkdir -p "$HOME/.fonts"
mkdir -p "$HOME/.config/fontconfig/conf.d"
echo "DONE"

echo -n "Downloading font files ... "
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -O "$HOME/.fonts/PowerlineSymbols.otf" -q
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -O "$HOME/.config/fontconfig/conf.d/10-powerline-symbols.conf" -q
echo "DONE"

echo "Regenerating font cache ..."
fc-cache -vf ~/.fonts/

cat <<EOF

Powerline fonts has been installed on your system. You need
to restart the application for this change to take effect.
If you still don't see what you expect, try deleting
symbolic link /etc/fonts/conf.d/70-no-bitmaps.conf
EOF

