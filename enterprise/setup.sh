#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

# Allow root login
function setup_ssh() {
    sudo sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo mkdir -p /root/.ssh && sudo cp /workspace/.ssh/authorized_keys $_
    sudo systemctl restart ssh
}

function setup_git() {
    echo "dir: $DIR"
    # cp "$DIR"
}

function setup() {
    echo "setting up enterprise"
}

# Check if host is an enterprise bp instance. If it is run 
[[ $(ghe-dev-hostname 2>/dev/null) == *".bpdev-us-east-1.github.net" ]] && setup