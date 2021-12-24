.PHONY: fish tmux

all:

nvim:
	./configure.sh configure_nvim

dircolors:
	./configure.sh configure_dircolors

clean-dircolors:
	./configure.sh clean_dircolors

xfce4-terminal:
	./configure.sh configure_xfce4_terminal

clean-xfce4-terminal:
	./configure.sh clean_xfce4_terminal

fonts:
	./configure.sh install_fonts

clean-fonts:
	./configure.sh clean_fonts

#############
# Git setup #
#############
GIT_CONFIGURED := $(shell grep -A1 "\[include\]" ~/.gitconfig | grep "path=${PWD}/gitconfig" | wc -l)
git:
ifeq ($(GIT_CONFIGURED),0)
	@echo "Configuring Git"
	@echo "[include]\n    path=${PWD}/gitconfig" >> ${HOME}/.gitconfig
else
	@echo "Git is already configured"
endif

####################
# Fish shell setup #
####################
fish:
	@echo "Configuring Fish"
	mkdir -p ~/.config/fish
	cp -av fish/* ~/.config/fish/

##############
# Tmux setup #
##############
tmux: ~/.tmux/plugins/tpm
	@echo "Configuring Tmux"
	cp tmux.conf ~/.tmux.conf
	~/.tmux/plugins/tpm/bin/clean_plugins
	~/.tmux/plugins/tpm/bin/update_plugins all
	~/.tmux/plugins/tpm/bin/install_plugins

~/.tmux/plugins/tpm:
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

####################
# Useful utilities #
####################
tc-test:
	awk -f true-color-test.awk

clean: clean-dircolors clean-xfce4-terminal clean-fonts
