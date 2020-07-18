#!/bin/bash

find "$(cd "$(dirname "$0")" && pwd)" -name 'setup.sh' -mindepth 2 -exec bash -c "chmod +x {} && {}" \;
