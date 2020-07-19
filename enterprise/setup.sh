#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

function setup_bash_profile() {
    sudo cp "$DIR/.bash_profile" /root
}

function setup_git() {
    sudo cp "$DIR/../git/.gitconfig" /root
}

# Allow root login
function setup_ssh() {
    sudo sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo mkdir -p /root/.ssh && sudo cp /workspace/.ssh/authorized_keys "$_"
    sudo systemctl restart ssh
}

function setup() {
    echo "setting up enterprise"
    setup_git
    setup_bash_profile
}

# Check if host is an enterprise bp instance. If it is run 
[[ $(ghe-dev-hostname 2>/dev/null) == *".bpdev-us-east-1.github.net" ]] && setup
