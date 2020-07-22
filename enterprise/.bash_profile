#!/bin/bash

# Session utils
alias reload='source ~/.bash_profile'
alias ls='ls -lhpA --group-directories-first'

# Enterprise utils
export PATH="$PATH:/workspace/enterprise2"
export OVERLAY_VM_FILES='yes'

alias gh.build='DEBUG_BUILD=1 chroot-build.sh'
alias gh.configure='chroot-configure.sh'
alias gh.start='chroot-start.sh'
alias gh.stop='chroot-stop.sh'
alias gh.reset='chroot-reset.sh'
alias gh.info='chroot-info.sh'
alias gh.proxy='sudo update-reverse-proxy'
alias gh.destroy='sudo shutdown 0'

gh.ssh () {
    BASH_PROFILE='/workspace/.dotfiles/enterprise/.appliance_bash_profile'
    [[ -f $BASH_PROFILE ]] && chroot-scp.sh --to "$BASH_PROFILE" /home/admin/.bash_profile
    chroot-ssh.sh "$@"
}
