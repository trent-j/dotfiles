#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
EM_DIR='/workspace/enterprise2/enterprise-manage'

setup_bash_profile () {
    cp "$DIR/bash/.bash_profile" "$HOME"
}

setup_gem_permissions () {
    chown -R "$USER" "$EM_DIR/vendor/gems/"
}

setup () {
    setup_bash_profile
    setup_gem_permissions
}

setup
