#!/bin/bash

find "$(cd "$(dirname "$0")" && pwd)" -mindepth 2 -name 'setup.sh' -exec bash -c "chmod +x {} && {}" \;
