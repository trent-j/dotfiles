#!/bin/bash

# shellcheck disable=SC2120

# Environment variables that will be forwarded from the host to the remote server
env_vars=(
    'GH_USER'
    'GH_PAT'
    'OCTOFACTORY_TOKEN'
    'REGISTRY_S3_BUCKET'
    'REGISTRY_S3_REGION'
    'REGISTRY_S3_SECRET_KEY'
    'REGISTRY_S3_ACCESS_KEY'
)

# Allows connecting host to send environment variables
setup_accept_env_vars () {
    for env_var in "${env_vars[@]}"; do
        echo "AcceptEnv $env_var" | sudo tee -a /etc/ssh/sshd_config
    done
}

# Allows root login
setup_root_login () {
    sudo sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo cat "$1" | sudo tee -a "$(setup_ssh_dir)/authorized_keys"
}

# Enables root login and acceptance of environment variables sent from connecting host
setup_sshd_config () {
    setup_root_login
    setup_accept_env_vars
}

setup_ssh_dir () {
    sudo mkdir -p "${1:-/root}/.ssh" && echo "$_"
}

restart_ssh () {
    sudo systemctl restart ssh
}
