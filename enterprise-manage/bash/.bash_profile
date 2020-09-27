#!/bin/bash

# Session utils
alias reload='source ~/.bash_profile'
alias ls='ls -lhpA --group-directories-first --color=auto'

# Dotfile utils
DOTFILES="$HOME/dotfiles"

alias dotfiles.update='(cd "$DOTFILES" && git pull origin master && cp "$DOTFILES/enterprise-manage/bash/.bash_profile" ~) && reload'

# Enterprise Manage utils
EM_DIR='/workspace/enterprise2/enterprise-manage'

alias em='cd "$EM_DIR"'
alias em.test='echo "hey 2"'

# Set rbenv
eval "$(rbenv init -)"
sudo rbenv global 2.6.4
