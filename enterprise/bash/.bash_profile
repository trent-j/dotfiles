#!/bin/bash

# Session utils
export DOTFILES='/workspace/.dotfiles'

alias reload='source ~/.bash_profile'
alias ls='ls -lhpA --group-directories-first --color=auto'
alias dotfiles.update='(cd "$DOTFILES" && git pull origin master && cp "$DOTFILES/enterprise/bash/.bash_profile" ~/) && reload'

# Docker utils
alias docker.octo.login='docker login octofactory.githubapp.com -u trent-j -p "$OCTOFACTORY_TOKEN"'
alias docker.gpr.login='docker login https://docker.pkg.github.com -u trent-j -p "$GH_PAT"'
alias docker.ghcr.login='docker login containers.pkg.github.com -u trent-j -p "$GH_PAT"'
alias docker.login='docker.octo.login && docker.gpr.login && docker.ghcr.login'

# Enterprise utils
export PATH="$PATH:/workspace/enterprise2"
export OVERLAY_VM_FILES='yes'
export ENABLE_HYDRO=1
export ENABLE_ISOLATION=1
export ENABLE_PACKAGES=1

alias gh.build='DEBUG_BUILD=1 chroot-build.sh'
alias gh.configure='chroot-configure.sh && gh.ssh setup_ssh'
alias gh.start='chroot-start.sh'
alias gh.stop='chroot-stop.sh'
alias gh.reset='chroot-reset.sh'
alias gh.info='chroot-info.sh'
alias gh.gw='chroot-add-gw.sh'
alias gh.configs='gh.ssh ghe_config_wrapper'
alias gh.secrets='gh.ssh ghe_config_wrapper -s'
alias gh.proxy='sudo update-reverse-proxy'
alias gh.init='gh.cr.update && docker.login && gh.build && gh.start && gh.gw && gh.configure && gh.proxy'
alias gh.rebuild='gh.stop && gh.reset && gh.build && gh.start && gh.configure'
alias gh.destroy='sudo shutdown 0'
alias gh.cr.update='(cd /workspace/enterprise2 && git stash && git fetch origin subdomain-proxy && git checkout subdomain-proxy)'

gh.ssh () {

    BASH_PROFILE="$DOTFILES/enterprise/bash/.appliance_bash_profile"
    [[ -f $BASH_PROFILE ]] && chroot-scp.sh --to "$BASH_PROFILE" /home/admin/.bash_profile > /dev/null

    if [[ $# -eq 0 ]]; then
        chroot-ssh.sh
    else
        chroot-ssh.sh ". .bash_profile && $*"
    fi
}
