set -U EDITOR nvim
set -U fish_greetings
set -g PATH $PATH ~/bin ~/.local/bin

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
    # fish_vi_key_bindings --no-erase does not overwrite $fish_key_bindings
    # we have to do it explicitely
    set fish_key_bindings "fish_vi_key_bindings"
end

# Disable shortening directories in prompt CWD path
set -g fish_prompt_pwd_dir_length 0

# Git prompt customization
set -g __fish_git_prompt_showupstream verbose
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showdirtystate 1

# Set some alternative chars (to be consistent with __git_ps1)
set -g __fish_git_prompt_char_upstream_prefix " u"
set -g __fish_git_prompt_char_upstream_ahead "+"
set -g __fish_git_prompt_char_upstream_behind "-"
set -g __fish_git_prompt_char_upstream_diverged "+"

# Set git prompt color
set -g __fish_git_prompt_color yellow
