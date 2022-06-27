echo "Running .profile..."

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# General aliases
alias ll='ls -la'
alias llr='ls -lrta'

# Git commands
alias g='git '
alias ga='git add '
alias gs='git status -sb '
alias gc='git checkout '
alias gd='git commit -m '
alias gp='git push '
alias gpo='git push origin'
alias gcm='git commit -m '
alias gpl='git pull '
alias gplr='git pull --rebase'

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

    # Write to the .bash_profile
    echo '\n# RUST\n. "$HOME/.cargo/env"\n' >> $HOME/.bash_profile
}

function install_go {
    GO_VERSION=${$1:=1.18.3}
    wget -O $GO_VERSION.linux-amd64.tar.gz https://golang.org/dl/$GO_VERSION.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf $GO_VERSION.linux-amd64.tar.gz && rm $GO_VERSION.linux-amd64.tar.gz
    echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
    echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
    echo 'export GO111MODULE=on' >> $HOME/.bash_profile
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
    go version
}

# function install_docker {

# }