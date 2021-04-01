#!/bin/bash

set -e

echo "running dotfiles" > /tmp/dotfiles-status

# shellcheck disable=SC2011,SC2156
find "$(cd "$(dirname "$0")" && pwd)" -mindepth 2 -name 'setup.sh' -exec bash -c "chmod +x {} && {}" \;
