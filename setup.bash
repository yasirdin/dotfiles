#!/usr/bin/env bash

set -euo pipefail

# Overwrite dotfiles in $HOME and soft symbolic link
ln -sf $(pwd)/.vimrc ~/.vimrc
ln -sf $(pwd)/.zshrc ~/.zshrc
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
ln -sf $(pwd)/.muttrc ~/.muttrc

# Install Tmux Plugin Manager (TPM)
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Homebrew
brew update
brew upgrade
brew install fzf  # Fuzzy finder
$(brew --prefix)/opt/fzf/install  # Install useful keybindings and fuzzy completion
brew install ripgrep

# From: https://gist.github.com/mislav/5189704
curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
      -o /usr/local/bin/tmux-vim-select-pane
chmod +x /usr/local/bin/tmux-vim-select-pane

# Install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Vundle and plugin installation
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall

# Python linters
python3 -m pip install --user --upgrade pip
python3 -m pip install --user mypy flake8

echo "Setup complete!"
