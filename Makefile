all:

git:
	./configure.sh configure_git

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

clean: clean-dircolors clean-xfce4-terminal clean-fonts
