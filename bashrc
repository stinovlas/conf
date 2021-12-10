export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_DESCRIBE_STYLE='contains'
export GIT_PS1_SHOWUPSTREAM="auto verbose"

source /usr/lib/git-core/git-sh-prompt

PS1='\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00;33m\]$(__git_ps1 " [%s]")\[\033[00m\] \$ '
PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00;33m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '

alias ls='ls --color'

eval $(dircolors $HOME/.dircolors)

# virtualenvwrapper settings
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

#setxkbmap -I $CONF_REPO -symbols 'pc+us-qwertz+cz-ucw-qwertz:2+inet(evdev)+capslock(groupshift)' -print \
#    | xkbcomp -I$CONF_REPO - :0
