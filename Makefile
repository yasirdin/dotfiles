.PHONY: all check-prerequisites check-homebrew check-xcode backup symlink install-tmux \
        brew-update brew-installs brew-install-terraform brew-install-alacritty \
        brew-install-ripgrep-fzf brew-install-gh brew-install-node brew-install-nvim brew-install-fonts \
        brew-install-raycast brew-install-leader-key install-opencode install-claude-code install-oh-my-zsh install-nvim-plugins install-python-linters install-python-lsps \
        turn-off-macos-dock-bounce configure-claude clean clean-nvim verify

# Detect architecture: Apple Silicon vs Intel
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),arm64)
    HOMEBREW_PREFIX := /opt/homebrew
else
    HOMEBREW_PREFIX := /usr/local
endif

all: check-prerequisites brew-installs install-oh-my-zsh install-tmux symlink install-nvim-plugins install-python-linters install-opencode install-claude-code configure-claude turn-off-macos-dock-bounce
	@echo "✓ Setup complete!"

check-prerequisites: check-xcode check-homebrew
	@mkdir -p ~/.config
	@echo "✓ Prerequisites satisfied"

check-xcode:
	@if ! xcode-select -p &>/dev/null; then \
		echo "Installing Xcode Command Line Tools..."; \
		xcode-select --install; \
		echo "Please re-run 'make all' after installation completes."; \
		exit 1; \
	fi
	@echo "✓ Xcode CLT installed"

check-homebrew:
	@if ! command -v brew &>/dev/null; then \
		echo "Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		echo "Please restart your terminal and re-run 'make all'"; \
		exit 1; \
	fi
	@echo "✓ Homebrew installed ($(HOMEBREW_PREFIX))"

BACKUP_DIR := ~/.dotfiles_backup/$(shell date +%Y%m%d_%H%M%S)

backup:
	@echo "Backing up existing configs to $(BACKUP_DIR)..."
	@mkdir -p $(BACKUP_DIR)
	@for f in ~/.zshrc ~/.tmux.conf ~/.amethyst.yml ~/.config/alacritty ~/.config/nvim ~/.claude/statusline.sh; do \
		if [ -e "$$f" ] && [ ! -L "$$f" ]; then \
			cp -r "$$f" $(BACKUP_DIR)/ 2>/dev/null && echo "  Backed up $$f"; \
		fi; \
	done
	@echo "✓ Backup complete"

symlink: backup
	@echo "Creating symlinks..."
	ln -sf $(shell pwd)/.zshrc ~/.zshrc
	ln -sf $(shell pwd)/.tmux.conf ~/.tmux.conf
	ln -sfn $(shell pwd)/alacritty ~/.config/alacritty
	ln -sfn $(shell pwd)/nvim ~/.config/nvim
	ln -sf $(shell pwd)/.amethyst.yml ~/.amethyst.yml
	@mkdir -p ~/.claude ~/.claude/themes
	ln -sf $(shell pwd)/claude/statusline.sh ~/.claude/statusline.sh
	@mkdir -p ~/.tmux
	ln -sf $(shell pwd)/tmux/status-right.sh ~/.tmux/status-right.sh
	ln -sf $(shell pwd)/claude/themes/solarized-blend.json ~/.claude/themes/solarized-blend.json
	@if [ ! -f ~/.zshrc.local ]; then \
		cp $(shell pwd)/.zshrc.local.example ~/.zshrc.local; \
		echo "  Created ~/.zshrc.local from example — fill in real secrets"; \
	fi
	@echo "✓ Symlinks created"

# settings.json holds account-specific secrets, so it isn't tracked; we merge
# only the sharable keys from settings.partial.json into it. See
# claude/merge-settings.jq for how hooks are preserved rather than replaced.
configure-claude:
	@echo "Configuring Claude Code (merging tracked prefs)..."
	@brew list jq &>/dev/null || brew install jq || true
	@mkdir -p ~/.claude
	@[ -s ~/.claude/settings.json ] || echo '{}' > ~/.claude/settings.json
	@tmp=$$(mktemp) && jq -s -f $(shell pwd)/claude/merge-settings.jq ~/.claude/settings.json $(shell pwd)/claude/settings.partial.json > "$$tmp" && mv "$$tmp" ~/.claude/settings.json
	@echo "✓ Claude prefs merged from claude/settings.partial.json"

install-tmux:
	@echo "Installing tmux and TPM..."
	@brew list tmux &>/dev/null || brew install tmux || true
	@if [ ! -d ~/.tmux/plugins/tpm ]; then \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	fi
	@echo "Installing tmux plugins..."
	@~/.tmux/plugins/tpm/bin/install_plugins || true
	@echo "✓ Tmux and plugins installed"

brew-update:
	@echo "Updating Homebrew..."
	@brew update || true
	@echo "Upgrading existing packages..."
	@brew upgrade || true
	@echo "✓ Homebrew updated"

brew-install-terraform:
	@brew tap hashicorp/tap 2>/dev/null || true
	@brew list hashicorp/tap/terraform &>/dev/null || brew install hashicorp/tap/terraform || true
	@echo "✓ Terraform checked/installed"

# TODO(by 2026-09-01): the alacritty Homebrew cask is deprecated (fails the
# macOS Gatekeeper/notarization check) and will be DISABLED on 2026-09-01,
# after which this install will fail. Before then, switch to building from
# source (cargo install alacritty) or move to a notarized terminal.
brew-install-alacritty:
	@brew list --cask alacritty &>/dev/null || brew install --cask alacritty || true
	@echo "✓ Alacritty checked/installed"

brew-install-ripgrep-fzf:
	@brew list fzf &>/dev/null || brew install fzf || true
	@if [ ! -f ~/.fzf.zsh ]; then \
		$(HOMEBREW_PREFIX)/opt/fzf/install --all --no-bash --no-fish; \
	fi
	@brew list ripgrep &>/dev/null || brew install ripgrep || true
	@echo "✓ fzf and ripgrep checked/installed"

brew-install-gh:
	@brew list gh &>/dev/null || brew install gh || true
	@echo "✓ GitHub CLI checked/installed"

brew-install-node:
	@brew list node &>/dev/null || brew install node || true
	@echo "✓ Node checked/installed"

brew-install-nvim:
	@brew list neovim &>/dev/null || brew install neovim || true
	@echo "✓ Neovim checked/installed"

brew-install-fonts:
	@brew list --cask font-iosevka-nerd-font &>/dev/null || brew install --cask font-iosevka-nerd-font || true
	@brew list --cask font-jetbrains-mono-nerd-font &>/dev/null || brew install --cask font-jetbrains-mono-nerd-font || true
	@echo "✓ Nerd Fonts checked/installed"

brew-install-raycast:
	@brew list --cask raycast &>/dev/null || brew install --cask raycast || true
	@echo "✓ Raycast checked/installed"

brew-install-leader-key:
	@brew list leader-key &>/dev/null || brew install leader-key || true
	@echo "✓ Leader Key checked/installed"

brew-installs: brew-update brew-install-fonts brew-install-terraform brew-install-alacritty brew-install-ripgrep-fzf brew-install-node brew-install-nvim brew-install-gh brew-install-raycast brew-install-leader-key
	@echo "✓ Brew packages installed"

install-opencode:
	@if [ ! -x ~/.opencode/bin/opencode ]; then \
		echo "Installing opencode..."; \
		curl -fsSL https://opencode.ai/install | bash; \
	fi
	@echo "✓ opencode installed"
	@echo "⚠️  Run 'opencode auth login' to authenticate"

install-claude-code:
	@if ! command -v claude &>/dev/null; then \
		echo "Installing Claude Code..."; \
		npm install -g @anthropic-ai/claude-code; \
	fi
	@echo "✓ Claude Code installed"

install-oh-my-zsh:
	@if [ ! -d ~/.oh-my-zsh ]; then \
		echo "Installing Oh My Zsh..."; \
		RUNZSH=no CHSH=no sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
	fi
	@echo "✓ Oh My Zsh installed"

install-nvim-plugins:
	@echo "Neovim plugin installation:"
	@echo "  [1] Install from lockfile (default, recommended)"
	@echo "  [2] Update to latest versions"
	@read -p "Choose [1/2]: " choice; \
	choice=$${choice:-1}; \
	if [ "$$choice" = "2" ]; then \
		echo "Updating plugins to latest versions..."; \
		nvim --headless "+Lazy! update" +qa; \
		echo "✓ Neovim plugins updated and lockfile regenerated"; \
	else \
		echo "Installing from lockfile..."; \
		nvim --headless "+Lazy! sync" +qa; \
		echo "✓ Neovim plugins installed from lockfile"; \
	fi

# Use pipx, not pip: Homebrew's Python is "externally managed" (PEP 668), so
# `pip install` fails with an externally-managed-environment error. pipx puts
# each CLI tool in its own venv and links the executables onto PATH.
install-python-linters:
	@echo "Installing Python linters..."
	@brew list pipx &>/dev/null || brew install pipx || true
	@pipx ensurepath >/dev/null 2>&1 || true
	pipx install mypy || true
	pipx install flake8 || true
	pipx install ruff || true
	@echo "✓ Python linters installed"

install-python-lsps:
	@brew list pipx &>/dev/null || brew install pipx || true
	@pipx ensurepath >/dev/null 2>&1 || true
	pipx install python-lsp-server || true
	pipx inject python-lsp-server python-lsp-black pyls-flake8 || true

turn-off-macos-dock-bounce:
	defaults write com.apple.dock no-bouncing -bool TRUE
	killall Dock

enable-key-repeat:
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	@echo "✓ Key repeat enabled (restart apps to take effect)"

clean-nvim:
	@echo "Cleaning up Neovim data..."
	rm -rf ~/.local/share/nvim/site/pack/packer
	rm -rf ~/.local/share/nvim/lazy
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim
	@echo "✓ Neovim data cleaned"

clean: clean-nvim
	@echo "Cleaning up all generated files..."
	rm -rf ~/.tmux/plugins
	@echo "✓ Cleanup complete"

verify:
	@echo "Verifying setup..."
	@nvim --version | head -1
	@nvim --headless -c 'qa' 2>&1 && echo "✓ Neovim config loads without errors"
	@nvim --headless -c 'lua print("lazy.nvim: " .. (pcall(require, "lazy") and "OK" or "FAIL"))' -c 'qa'
	@nvim --headless -c 'lua print("telescope: " .. (pcall(require, "telescope") and "OK" or "FAIL"))' -c 'qa'
	@nvim --headless -c 'lua print("Navigator: " .. (pcall(require, "Navigator") and "OK" or "FAIL"))' -c 'qa'
	@nvim --headless -c 'lua print("mini.files: " .. (pcall(require, "mini.files") and "OK" or "FAIL"))' -c 'qa'
	@nvim --headless -c 'lua print("neo-tree: " .. (pcall(require, "neo-tree") and "OK" or "FAIL"))' -c 'qa'
	@nvim --headless -c 'lua print("nvim-cmp: " .. (pcall(require, "cmp") and "OK" or "FAIL"))' -c 'qa'
	@tmux -V
	@test -d ~/.tmux/plugins/vim-tmux-navigator && echo "✓ vim-tmux-navigator: OK" || echo "✗ vim-tmux-navigator: MISSING"
	@test -d ~/.tmux/plugins/tmux-resurrect && echo "✓ tmux-resurrect: OK" || echo "✗ tmux-resurrect: MISSING"
	@test -d ~/.tmux/plugins/tmux-continuum && echo "✓ tmux-continuum: OK" || echo "✗ tmux-continuum: MISSING"
	@echo "✓ Verification complete"
