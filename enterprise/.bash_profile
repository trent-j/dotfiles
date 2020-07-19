#!/bin/bash

export PATH="$PATH:/workspace/enterprise2"

# Session utils
alias reload='source ~/.bash_profile'
alias ls='ls -lhpA --group-directories-first'

# Enterprise utils
alias gh.ssh='chroot-nsenter.sh'
alias gh.destroy='sudo shutdown 0'
