#!/bin/bash

# Allow root login
sudo sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo mkdir -p /root/.ssh && sudo cp /workspace/.ssh/authorized_keys $_
sudo systemctl restart ssh
