#!/bin/bash

function add_aliases_general {
    echo -e "\n# General aliases
alias ll='ls -la'
alias llr='ls -lrta'" >> $HOME/.profile
}

function add_aliases_git {
    echo -e "\n# Git commands
alias g='git '
alias ga='git add '
alias gs='git status '
alias gsb='git status -sb '
alias gc='git checkout '
alias gp='git push '
alias gpf='git push -f '
alias gpo='git push origin '
alias gcm='git commit -m '
alias gpl='git pull '
alias gplr='git pull --rebase '" >> $HOME/.profile
}

# Functions (do be moved out)
function install_common_deps {
    sudo apt update
    sudo apt install git htop jq unzip wget -y
}

function install_build_deps {
    sudo apt update
    sudo make clang pkg-config libgmp-dev libssl-dev build-essential python3 python3-venv python3-dev -y
}

function install_rust {
    sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
    source $HOME/.cargo/env
    rustup update stable --force
    # Write to the .profile
    echo '\n# RUST\n. "$HOME/.cargo/env"\n' >> $HOME/.profile
}

function install_go {
    GO_VERSION=${$1:-"1.18.3"}
    wget -O go$GO_VERSION.linux-amd64.tar.gz https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz && rm go$GO_VERSION.linux-amd64.tar.gz
    echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
    echo 'export GOPATH=$HOME/go' >> $HOME/.profile
    echo 'export GO111MODULE=on' >> $HOME/.profile
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.profile && . $HOME/.profile
    go version
}

function create_user {
    useradd dan -m --shell /bin/bash
    usermod dan -aG sudo
    echo 'Update the password: '
    passwd dan
    echo 'dan ALL=(ALL) ALL' >> /etc/sudoers
    # nano /etc/ssh/sshd_config -> PermitRootLogin no
    sed -i 's/^PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
    sudo service sshd restart
    su -l dan
}

function install_docker {
    #install docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    #install docker-compose
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    rm get-docker.sh
    sudo usermod -aG docker $USER
    # curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_docker.sh | bash
}

echo "Adding aliases."
add_aliases_general
add_aliases_git

source ~/.profile