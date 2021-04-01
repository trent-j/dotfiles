#!/bin/bash

set -e
set -x

# shellcheck disable=SC2011,SC2156
find "$(cd "$(dirname "$0")" && pwd)" -mindepth 2 -name 'setup.sh' -exec bash -c "chmod +x {} && {} 2>&1 >> /tmp/dotfile-log" \;
