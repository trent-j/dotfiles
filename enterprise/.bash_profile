#!/bin/bash

alias destroy='sudo shutdown 0'
alias reload='source ~/.bash_profile'

# shellcheck disable=SC2011,SC2016
function ls() { ls -lhpA --group-directories-first | xargs -0I % echo '%;!;%;;' | xargs -d\; -n2 bash -c 'echo "$0" | awk "\$9 "${1}"~ /^\./ {print}"'; }