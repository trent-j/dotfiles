#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
EM_DIR='/workspace/enterprise2/enterprise-manage'

setup_bash () {
    cat "$DIR/bash/.bashrc" >> ~/.bashrc
}

setup_gem_permissions () {
    chown -R "$USER" "$EM_DIR/vendor/gems/"
}

setup () {
    setup_bash
    setup_gem_permissions
}

setup
