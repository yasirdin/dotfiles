all: symlink install-tmux brew-installs tmux-vim-select-pane install-oh-my-zsh install-vundle-vim-plugins install-python-linters

# Overwrite dotfiles in $HOME and soft symbolic link
symlink:
	ln -sf $(shell pwd)/.vimrc ~/.vimrc
	ln -sf $(shell pwd)/.zshrc ~/.zshrc
	ln -sf $(shell pwd)/.tmux.conf ~/.tmux.conf
	ln -sf $(shell pwd)/.muttrc ~/.muttrc

install-tmux:
	# Install Tmux Plugin Manager (TPM)
	if [ ! -d ~/.tmux/plugins/tpm ]; then \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	fi

brew-update:
	brew update
	brew upgrade

brew-installs: brew-update
	brew install fzf
	$(shell brew --prefix)/opt/fzf/install --all
	brew install ripgrep

tmux-vim-select-pane:
	curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
		  -o /usr/local/bin/tmux-vim-select-pane
	chmod +x /usr/local/bin/tmux-vim-select-pane

install-oh-my-zsh:
	if [ ! -d ~/.oh-my-zsh ]; then \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
	fi

install-vundle-vim-plugins:
	if [ ! -d ~/.vim/bundle/Vundle.vim ]; then \
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; \
	fi
	vim +PluginInstall +qall

install-python-linters:
	python3 --version
	python3 -m pip install --user --upgrade pip
	python3 -m pip install --user mypy flake8
