#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"

setup_bash () {
    cat "$DIR/bash/.bashrc" >> ~/.bashrc
}

setup () {
    setup_bash
}

setup
