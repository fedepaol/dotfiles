#!/bin/bash

useradd -m fpaoline
usermod -aG wheel fpaoline
passwd fpaoline
dnf install vim tmux git zsh
chsh -s /bin/zsh fpaoline

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
dnf install -y libvirt
systemctl start libvirtd
systemctl enable libvirtd
usermod -aG libvirt fpaoline

# Install Go (latest stable)
GO_VERSION=$(curl -fsSL https://go.dev/VERSION?m=text | head -1)
curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/fpaoline/.zshrc

# Install kubectl
curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

# Install kind
curl -fsSL https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64 -o /usr/local/bin/kind
chmod +x /usr/local/bin/kind

# Install Claude Code
npm install -g @anthropic-ai/claude-code

runuser -l fpaoline -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

dnf install -y sway swaylock swayidle wofi swaybg kanshi waybar mako grim slurp wl-clipboard
dnf install -y autoway kanshi thunar pipewire xdg-desktop-portal xdg-desktop-portal-wlr

# Clone dotfiles and symlink configs
DOTFILES=/home/fpaoline/dotfiles
runuser -l fpaoline -c "git clone https://github.com/fedepaol/dotfiles $DOTFILES"

runuser -l fpaoline -c "
mkdir -p ~/.config/ghostty ~/.config/i3 ~/.config/i3status ~/.config/kanshi ~/.config/waybar

# Ghostty
ln -sf $DOTFILES/ghostty/config ~/.config/ghostty/config

# Git
ln -sf $DOTFILES/git/gitconfig ~/.gitconfig
ln -sf $DOTFILES/git/gitignore ~/.gitignore
ln -sf $DOTFILES/git/gitmessage ~/.gitmessage

# i3
ln -sf $DOTFILES/i3/i3/config ~/.config/i3/config
ln -sf $DOTFILES/i3/i3/backlight.sh ~/.config/i3/backlight.sh
ln -sf $DOTFILES/i3/i3/i3-battery-popup ~/.config/i3/i3-battery-popup
ln -sf $DOTFILES/i3/i3status/i3status.conf ~/.config/i3status/config

# Kanshi
ln -sf $DOTFILES/kanshi/config ~/.config/kanshi/config

# Neovim
ln -sfn $DOTFILES/nvim ~/.config/nvim

# lazy.nvim plugin manager
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim

# tmux
ln -sf $DOTFILES/tmux/tmux.conf ~/.tmux.conf

# Vim
ln -sf $DOTFILES/vim/vimrc ~/.vimrc

# Waybar
ln -sf $DOTFILES/waybar/config ~/.config/waybar/config
ln -sf $DOTFILES/waybar/style.css ~/.config/waybar/style.css

# Zsh (overwrite the one oh-my-zsh created)
ln -sf $DOTFILES/zsh/zshrc ~/.zshrc
"

