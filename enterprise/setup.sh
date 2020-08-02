#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

setup_bash_profile () {
    sudo cp "$DIR/bash/.bash_profile" /root
}

setup_git () {
    sudo cp "$DIR/git/.gitconfig" /root
    (cd /workspace/enterprise2 && git stash && git fetch origin container-registry && git checkout container-registry)
}

# Allow root login
setup_ssh () {
    sudo sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    echo 'AcceptEnv OCTOFACTORY_TOKEN' | sudo tee -a /etc/ssh/sshd_config
    sudo mkdir -p /root/.ssh && sudo cp "$DIR/ssh/config" "$_"
    sudo cat /workspace/.ssh/authorized_keys | sudo tee -a /root/.ssh/authorized_keys
    sudo systemctl restart ssh
}

setup () {
    setup_ssh
    setup_git
    setup_bash_profile
}

# Check if host is an enterprise bp instance. If it is run 
[[ $(ghe-dev-hostname 2>/dev/null) == *".bpdev-us-east-1.github.net" ]] && setup
