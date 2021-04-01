#!/bin/bash

set -e

# shellcheck disable=SC2011,SC2156
find "$(cd "$(dirname "$0")" && pwd)" -mindepth 2 -name 'setup.sh' -exec bash -c "chmod +x {} && sudo {} 2>&1 >> /tmp/dotfile-log" \;
