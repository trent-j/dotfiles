#!/bin/bash

# Allow root login
sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
mkdir -p /root/.ssh && cp ~/.ssh/authorized_keys $_
systemctl restart ssh
