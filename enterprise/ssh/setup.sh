#!/bin/bash

# shellcheck disable=SC2120

set -e

ssh_config=$(cat << EOF
Host *
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  LogLevel ERROR
EOF
)

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

# Setup users ssh config file (
#   - The first parameter to this function should be the path to the users home directory (defaults to '/root')
setup_ssh_config () {

    CONFIG="$(setup_ssh_dir "$1")/config"

    echo "$ssh_config" | sudo tee "$CONFIG"

    for env_var in "${env_vars[@]}"; do
        echo "  SendEnv $env_var" | sudo tee -a "$CONFIG"
    done
}

# Allows connecting host to send environment variables
setup_accept_env_vars () {

    for env_var in "${env_vars[@]}"; do
        echo "AcceptEnv $env_var" | sudo tee -a /etc/ssh/sshd_config
    done
}

# Allows root login
#   - The first parameter to this function should be the path to an authorized keys file.
setup_root_login () {
    sudo sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo cat "$1" | sudo tee -a "$(setup_ssh_dir)/authorized_keys"
}

# Creates users ssh directory and returns the absolute path
setup_ssh_dir () {
    sudo mkdir -p "${1:-/root}/.ssh" && echo "$_"
}

# Restart SSH
restart_ssh () {
    sudo systemctl restart ssh
}

# Sets up SSH. Enables root login and sets up SSH to send and recieve the environment variables defined in $env_vars
while (( "$#" )); do
    case "$1" in
        -h | --home) home="$2" && shift 2;;
        -k | --keys) keys="$2" && shift 2;;
    esac
done

[[ -z $keys ]] && echo "path to authorized keys is required" && exit 1

setup_root_login "$keys"
setup_accept_env_vars
setup_ssh_config

# If home directory supplied setup ssh config in specified directory
[[ -n $home ]] && setup_ssh_config "$home"

restart_ssh
