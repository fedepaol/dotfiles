#!/bin/bash

dnf install -y vim git hg wget tar libvirt libvirt-devel libvirt-daemon-kvm qemu-kvm gcc gcc-c++ zsh make chsh podman jq
sudo systemctl enable --now libvirtd

wget https://dl.google.com/go/go1.14.1.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.14.1.linux-amd64.tar.gz
cat >> /etc/libvirt/libvirtd.conf <<- EOF
listen_tls = 0
listen_tcp = 1
auth_tcp="none"
tcp_port = "16509"
EOF

echo 'LIBVIRTD_ARGS="--listen"' >> /etc/sysconfig/libvirtd
echo -e "[main]\ndns=dnsmasq" | tee /etc/NetworkManager/conf.d/openshift.conf
echo server=/tt.testing/192.168.126.1 | tee /etc/NetworkManager/dnsmasq.d/openshift.conf
iptables -I INPUT -p tcp -s 192.168.126.0/24 -d 192.168.122.1 --dport 16509 -j ACCEPT -m comment --comment "Allow insecure libvirt clients"

systemctl reload NetworkManager

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
useradd -m fpaoline
gpasswd wheel -a fpaoline

chmod 600 fede.pub
mv fede.pub ~fpaoline

su - fpaoline <<'EOF'
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bashrc
PATH=$PATH:/usr/local/go/bin:~/go/bin
git clone https://github.com/fedepaol/dotfiles.git
cp dotfiles/.vimrc ~
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/openshift/installer.git
pushd ./installer
	TAGS=libvirt hack/build.sh
popd
mkdir ~/openshift
cp installer/bin/openshift-install openshift/
mkdir .ssh
mv fede.pub .ssh/authorized_keys
restorecon -R -v ~/.ssh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git config --global user.name "Federico Paolinelli"
git config --global user.email "fpaoline@redhat.com"
git config --global commit.template "~/.gitmessage"

cat >> ~/.gitmessage <<- EOM 


Signed-off-by: Federico Paolinelli <fpaoline@redhat.com>
EOM

echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.zshrc
EOF
