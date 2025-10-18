#!/bin/bash

useradd -m fpaoline
usermod -aG wheel fpaoline
passwd fpaoline
dnf install vim tmux git zsh

yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
yum -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
systemctl enable docker
usermod -aG docker fpaoline

dnf install -y nodejs python-pip make


runuser -l fpaoline -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

sudo dnf install sway swaylock swayidle wofi swaybg kanshi waybar mako grim slurp wl-clipboard
sudo dnf install autoway kanshi thunar
