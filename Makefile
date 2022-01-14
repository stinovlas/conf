.PHONY: dircolors fish git nvim tmux tc-test

all:

###################
# Dircolors setup #
###################
dircolors:
	@echo "Configuring dircolors"
	@curl --silent -fLo ${HOME}/.dircolors \
		https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
	@fish -c "set -Ux LS_COLORS $(shell dircolors ~/.dircolors -c | cut -d\  -f3-)"

###############
# Fonts setup #
###############
fonts: .powerline-fonts
	@echo "Configuring fonts"
	@cd .powerline-fonts && ./install.sh
	@fc-cache -vf

.powerline-fonts:
	@echo "Downloading powerline-fonts"
	@git clone https://github.com/powerline/fonts.git .powerline-fonts

clean-fonts: .powerline-fonts
	@echo "Cleaning fonts"
	@cd .powerline-fonts && sh uninstall.sh
	@rm -rf .powerline-fonts

####################
# Fish shell setup #
####################
fish:
	@echo "Configuring Fish"
	@ln -sf -t ${HOME}/.config/ ${PWD}/fish

#############
# Git setup #
#############
GIT_CONFIGURED := $(shell grep -A1 "\[include\]" ${HOME}/.gitconfig | grep "path=${PWD}/gitconfig" | wc -l)
git:
ifeq ($(GIT_CONFIGURED),0)
	@echo "Configuring Git"
	@echo "[include]\n    path=${PWD}/gitconfig" >> ${HOME}/.gitconfig
else
	@echo "Git is already configured"
endif

################
# NeoVim setup #
################
PYNVIM_INSTALLED := $(shell python3 -c 'import neovim' 2> /dev/null; echo $$?)
PLUG_VIM_INSTALLED := $(shell test -f ${HOME}/.config/nvim/autoload/plug.vim; echo $$?)
nvim:
ifneq ($(PYNVIM_INSTALLED),0)
	@echo "Installing pynvim"
	sudo python3 -m pip install -U pynvim
endif
	@echo "Configuring nvim"
	@mkdir -p ${HOME}/.config/nvim
	@ln -sf -t ${HOME}/.config/nvim ${PWD}/init.vim
	@ln -sf -t ${HOME}/.config/nvim ${PWD}/lsp.lua
ifneq ($(PLUG_VIM_INSTALLED),0)
	@echo "Downloading plug.vim"
	curl --silent -fLo $NVIM_CONF/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
	@mkdir -p ${HOME}/.config/nvim/plugged
	@echo "Installing NeoVim plugins"
	@nvim +PlugUpgrade +PlugInstall +qall

##############
# Tmux setup #
##############
tmux: ${HOME}/.tmux/plugins/tpm
	@echo "Configuring Tmux"
	@ln -sf -t ${HOME} ${PWD}/.tmux.conf
	@echo "Refreshing Tmux plugins"
	@${HOME}/.tmux/plugins/tpm/bin/clean_plugins
	@${HOME}/.tmux/plugins/tpm/bin/update_plugins all
	@${HOME}/.tmux/plugins/tpm/bin/install_plugins

${HOME}/.tmux/plugins/tpm:
	@echo "Cloning Tmux plugin manager"
	mkdir -p ${HOME}/.tmux/plugins
	@git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

####################
# Useful utilities #
####################
tc-test:
	awk -f true-color-test.awk
