#!/bin/bash

set -x

DIR="$(cd "$(dirname "$0")" && pwd)"

setup_bash_profile () {
    sudo cp "$DIR/bash/.bash_profile" /root
}

setup_git () {
    sudo cp "$DIR/git/.gitconfig" /root
}

setup_ssh () {
    sudo chmod +x "$DIR/ssh/setup.sh" && "$_" --keys '/workspace/.ssh/authorized_keys'
    # "$DIR/ssh/setup.sh" --keys '/workspace/.ssh/authorized_keys'
    #KEYS='/workspace/.ssh/authorized_keys' "$DIR/ssh/setup.sh"
}

setup_shellcheck () {
    sudo apt-get install shellcheck
}

setup () {
    setup_git
    setup_bash_profile
    setup_ssh
    setup_shellcheck
}

# Check if host is an enterprise bp instance. If it is run
[[ $(ghe-dev-hostname 2>/dev/null) == *".bpdev-us-east-1.github.net" ]] && setup
