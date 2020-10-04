#!/usr/bin/env bash

set -euo pipefail

# Overwrite dotfiles in $HOME and soft symbolic link
ln -sf $(pwd)/.vimrc ~/.vimrc
ln -sf $(pwd)/.zshrc ~/.zshrc
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf

# Install Tmux Plugin Manager (TPM)
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# From: https://gist.github.com/mislav/5189704
curl -fsSL https://gist.github.com/mislav/5189704/raw/install.sh | bash -e

# Install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Vundle and plugin installation
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall

echo "Setup complete!"
