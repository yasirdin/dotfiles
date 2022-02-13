.PHONY: all
all: symlink install-tmux brew-installs tmux-vim-select-pane install-oh-my-zsh install-packer-nvim install-python-linters turn-off-macos-dock-bounce

# Overwrite dotfiles in $HOME and soft symbolic link
symlink:
	ln -sf $(shell pwd)/.vimrc ~/.vimrc
	ln -sf $(shell pwd)/.zshrc ~/.zshrc
	ln -sf $(shell pwd)/.tmux.conf ~/.tmux.conf
	ln -sf $(shell pwd)/.muttrc ~/.muttrc
	ln -sf $(shell pwd)/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
	ln -sf $(shell pwd)/nvim ~/.config

install-tmux:
	# Install Tmux Plugin Manager (TPM)
	if [ ! -d ~/.tmux/plugins/tpm ]; then \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	fi

brew-update:
	brew update
	brew upgrade

brew-install-terraform:
	brew tap hashicorp/tap
	brew install hashicorp/tap/terraform

brew-install-alacritty:
	brew install --cask alacritty

brew-install-ripgrep-fzf:
	brew install fzf
	$(shell brew --prefix)/opt/fzf/install --all
	brew install ripgrep

brew-install-nvim:
	brew install nvim

brew-install-fonts:
	brew install --cask font-iosevka-nerd-font

brew-installs: brew-update brew-install-fonts brew-install-terraform brew-install-alacritty brew-install-ripgrep-fzf brew-install-nvim

tmux-vim-select-pane:
	curl -fsSL https://raw.github.com/mislav/dotfiles/1500cd2/bin/tmux-vim-select-pane \
		  -o /usr/local/bin/tmux-vim-select-pane
	chmod +x /usr/local/bin/tmux-vim-select-pane

install-oh-my-zsh:
	if [ ! -d ~/.oh-my-zsh ]; then \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
	fi

install-packer-nvim:
	if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then \
		git clone --depth 1 https://github.com/wbthomason/packer.nvim \
			~/.local/share/nvim/site/pack/packer/start/packer.nvim; \
	fi
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

install-python-linters:
	python3 --version
	python3 -m pip install --user --upgrade pip
	python3 -m pip install --user mypy flake8

# Installation location has to be in $PATH for nvim LSP to access
install-python-lsps:
	python3 -m pip install --user python-lsp-server
	python3 -m pip install --user python-lsp-black
	python3 -m pip install --user pyls-flake8

turn-off-macos-dock-bounce:
	defaults write com.apple.dock no-bouncing -bool TRUE
	killall Dock

install-node-js:
	curl -sL install-node.vercel.app/lts | bash
