#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

# shellcheck disable=SC1090
. "$DIR/ssh/ssh.sh"

setup_bash_profile () {
    sudo cp "$DIR/bash/.bash_profile" /root
}

setup_git () {
    sudo cp "$DIR/git/.gitconfig" /root
}

# Allow root login
setup_ssh () {
    setup_root_login /workspace/.ssh/authorized_keys
    restart_ssh
    # sudo sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    # for ENV_VAR in 'OCTOFACTORY_TOKEN' 'GH_PAT' 'REGISTRY_S3_BUCKET' 'REGISTRY_S3_REGION' 'REGISTRY_S3_SECRET_KEY' 'REGISTRY_S3_ACCESS_KEY'; do
    #     echo "AcceptEnv $ENV_VAR" | sudo tee -a /etc/ssh/sshd_config
    # done
    # sudo mkdir -p /root/.ssh && sudo cp "$DIR/ssh/config" "$_"
    # sudo cat /workspace/.ssh/authorized_keys | sudo tee -a /root/.ssh/authorized_keys
    # sudo systemctl restart ssh
}

setup () {
    setup_ssh
    setup_git
    setup_bash_profile
}

# Check if host is an enterprise bp instance. If it is run
[[ $(ghe-dev-hostname 2>/dev/null) == *".bpdev-us-east-1.github.net" ]] && setup
