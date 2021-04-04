#!/bin/bash

# Session utils
export DOTFILES='/workspace/.dotfiles'

alias reload='source ~/.bash_profile'
alias ls='ls -lhpA --group-directories-first --color=auto'
alias dotfiles.update='(cd "$DOTFILES" && git pull origin master && cp "$DOTFILES/enterprise/bash/.bash_profile" ~/) && reload'

# Git utils
git.checkout () { git fetch origin "$1" && git checkout "$1"; }
git.ignore-build () { echo 'root-default' >> /workspace/enterprise2/.gitignore; }

# Docker utils
d.login () { echo "$2" | docker login "$1" --username "$GH_USER" --password-stdin; }
alias docker.octo.login='d.login octofactory.githubapp.com "$OCTOFACTORY_TOKEN"'
alias docker.gpr.login='d.login https://docker.pkg.github.com "$GH_PAT"'
alias docker.ghcr.login='d.login containers.pkg.github.com "$GH_PAT"'
alias docker.login='docker.octo.login && docker.gpr.login && docker.ghcr.login'

# Enterprise utils
export PATH="$PATH:/workspace/enterprise2"
#export OVERLAY_VM_FILES='yes'
export ENABLE_ISOLATION=1
export ENABLE_PACKAGES=1

alias gh.build='DEBUG_BUILD=1 chroot-build.sh'
alias gh.start='chroot-start.sh'
alias gh.stop='chroot-stop.sh'
alias gh.reset='chroot-reset.sh'
alias gh.info='chroot-info.sh'
alias gh.gw='chroot-add-gw.sh'
alias gh.configs='gh.ssh gh.config.wrapper'
alias gh.secrets='gh.ssh gh.config.wrapper -s'
alias gh.proxy='sudo update-reverse-proxy'
alias gh.init='git.ignore-build && docker.login && gh.build && gh.start && gh.gw && gh.configure && gh.proxy'
alias gh.rebuild='gh.stop && gh.reset && gh.build && gh.start && gh.gw && gh.configure'
alias gh.destroy='sudo shutdown 0'
alias gh.git.init='(cd /workspace/enterprise2 && git stash && git.checkout packages-subdomain-routes)'
alias gh.config-apply='gh.ssh gh.config-apply'
alias gh.config-apply.system='gh.ssh gh.config-apply.system'
alias gh.config-apply.migrations='gh.ssh gh.config-apply.migrations'
alias gh.config-apply.applications='gh.ssh gh.config-apply.applications'
alias gh.config-apply.log='chroot-ssh.sh "tail -f /data/user/common/ghe-config.log"'

gh.configure () {
    gh.appliance.init
    gh.ssh "systemctl is-active enterprise-manage" --attempts 100 --interval 3 || echo "enterprise-manage never came up" && exit 1
    chroot-configure.sh
}

gh.ssh () {

    [[ $# -eq 0 ]] && chroot-ssh.sh && return 0

    local CMD="$1"
    local ATTEMPTS=1
    local INTERVAL=1

    shift 1

    while (( "$#" )); do
        case "$1" in
            --attempts) ATTEMPTS="$2"; shift 2;;
            --interval) INTERVAL="$2"; shift 2;;
            *) shift 1;;
        esac
    done

    for i in $(seq 1 "$ATTEMPTS"); do

        chroot-ssh.sh ". .bash_profile && $CMD" && return 0

        if [[ $i -eq $ATTEMPTS ]]; then
            echo 'Failed to execute SSH command, exhausted retries'
            return 1
        else
            echo "Retrying failed SSH command. retry attempt: $i, interval: $INTERVAL"
            sleep "$INTERVAL"
        fi
    done
}

gh.appliance.init () {

    # Setup bash profile for admin and root users
    chroot-scp.sh --to "$DOTFILES/enterprise/bash/.appliance_bash_profile" /home/admin/.bash_profile > /dev/null
    gh.ssh 'sudo cp /home/admin/.bash_profile /root/.bash_profile'

    # Setup SSH to allow root login and accept environment variables set on the bp-dev instance
    chroot-scp.sh --to "$DOTFILES/enterprise/ssh/setup.sh" /tmp/ssh-setup.sh > /dev/null
    gh.ssh '/tmp/ssh-setup.sh --keys /home/admin/.ssh/authorized_keys > /dev/null'

    # Set azure secrets
    gh.ssh 'gh.azure.setup' --attempts 100 --interval 3
}

gh.generate-pat () { gh.ssh 'gh.generate-pat'; }
