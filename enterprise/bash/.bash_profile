#!/bin/bash

# Session utils
export DOTFILES='/workspace/.dotfiles'

alias reload='source ~/.bash_profile'
alias ls='ls -lhpA --group-directories-first --color=auto'
alias dotfiles.update='(cd "$DOTFILES" && git pull origin master && cp "$DOTFILES/enterprise/bash/.bash_profile" ~/) && reload'

# Docker utils
d.login () { echo "$2" | docker login "$1" --username "$GH_USER" --password-stdin; }
alias docker.octo.login='d.login octofactory.githubapp.com "$OCTOFACTORY_TOKEN"'
alias docker.gpr.login='d.login https://docker.pkg.github.com "$GH_PAT"'
alias docker.ghcr.login='d.login containers.pkg.github.com "$GH_PAT"'
alias docker.login='docker.octo.login && docker.gpr.login && docker.ghcr.login'

# Enterprise utils
export PATH="$PATH:/workspace/enterprise2"
export OVERLAY_VM_FILES='yes'
export ENABLE_ISOLATION=1
export ENABLE_PACKAGES=1

alias gh.build='DEBUG_BUILD=1 chroot-build.sh'
alias gh.configure='chroot-configure.sh && gh.appliance.setup'
alias gh.start='chroot-start.sh'
alias gh.stop='chroot-stop.sh'
alias gh.reset='chroot-reset.sh'
alias gh.info='chroot-info.sh'
alias gh.gw='chroot-add-gw.sh'
alias gh.configs='gh.ssh gh.config.wrapper'
alias gh.secrets='gh.ssh gh.config.wrapper -s'
alias gh.proxy='sudo update-reverse-proxy'
alias gh.init='docker.login && gh.build && gh.start && gh.gw && gh.configure && gh.proxy'
alias gh.rebuild='gh.stop && gh.reset && gh.build && gh.start && gh.gw && gh.configure'
alias gh.destroy='sudo shutdown 0'
alias gh.git.init='(cd /workspace/enterprise2 && git stash && git fetch origin packages-subdomain-ci && git checkout packages-subdomain-ci)'
alias gh.config-apply='gh.ssh gh.config-apply'
alias gh.config-apply.system='gh.ssh gh.config-apply.system'
alias gh.config-apply.migrations='gh.ssh gh.config-apply.migrations'
alias gh.config-apply.applications='gh.ssh gh.config-apply.applications'
alias gh.config-apply.log='chroot-ssh.sh "tail -f /data/user/common/ghe-config.log"'

gh.ssh () {

    if [[ $# -eq 0 ]]; then
        chroot-ssh.sh
    else
        chroot-ssh.sh ". .bash_profile && $*"
    fi
}

gh.appliance.setup () {

    # Setup bash profile for admin and root users
    BASH_PROFILE="$DOTFILES/enterprise/bash/.appliance_bash_profile"
    chroot-scp.sh --to "$BASH_PROFILE" /home/admin/.bash_profile > /dev/null
    gh.ssh 'sudo cp /home/admin/.bash_profile /root/.bash_profile'

    # Setup SSH to allow root login and accept environment variables set on the bp-dev instance
    SSH_SETUP="$DOTFILES/enterprise/ssh/setup.sh"
    chroot-scp.sh --to "$SSH_SETUP" /tmp/ssh-setup.sh > /dev/null
    gh.ssh '/tmp/ssh-setup.sh --keys /home/admin/.ssh/authorized_keys > /dev/null'

    # Set S3 configs and reload packages
    gh.ssh 'gh.s3.setup'
}
