#!/bin/bash

# ============================================
# Alex.Dots - Dotfiles Installer
# ============================================
# Idempotent installer for macOS and Linux/WSL
# Usage: ./install.sh
# ============================================

set -e

# ============================================
# Colors and formatting
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ============================================
# Helper functions
# ============================================
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

command_exists() {
    command -v "$1" &> /dev/null
}

# ============================================
# Detect OS
# ============================================
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version 2>/dev/null; then
            OS="wsl"
        else
            OS="linux"
        fi
    else
        error "Unsupported OS: $OSTYPE"
    fi
    info "Detected OS: $OS"
}

# ============================================
# Get dotfiles directory (where this script lives)
# ============================================
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================
# Banner
# ============================================
show_banner() {
    echo -e "${BOLD}${BLUE}"
    echo "  ╔═══════════════════════════════════════╗"
    echo "  ║         Alex.Dots Installer           ║"
    echo "  ║   Zsh + Starship + Tmux + fnm + Git   ║"
    echo "  ╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

# ============================================
# Update system (Linux/WSL only)
# ============================================
update_system() {
    if [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
        info "Updating system packages..."
        sudo apt update && sudo apt upgrade -y
        success "System updated"
    fi
}

# ============================================
# Install Homebrew
# ============================================
install_homebrew() {
    if command_exists brew; then
        success "Homebrew already installed"
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for this session
        if [[ "$OS" == "macos" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
        success "Homebrew installed"
    fi
}

# ============================================
# Install packages from Brewfile
# ============================================
install_packages() {
    info "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    success "Packages installed"
}

# ============================================
# Install Zsh plugins
# ============================================
install_zsh_plugins() {
    local ZSH_PLUGINS_DIR="$HOME/.zsh"
    mkdir -p "$ZSH_PLUGINS_DIR"

    # zsh-autosuggestions
    if [[ -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]]; then
        success "zsh-autosuggestions already installed"
    else
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
        success "zsh-autosuggestions installed"
    fi

    # zsh-syntax-highlighting
    if [[ -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
        success "zsh-syntax-highlighting already installed"
    else
        info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
        success "zsh-syntax-highlighting installed"
    fi
}

# ============================================
# Install TPM (Tmux Plugin Manager)
# ============================================
install_tpm() {
    local TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [[ -d "$TPM_DIR" ]]; then
        success "TPM already installed"
    else
        info "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        success "TPM installed"
    fi

    # Install tmux plugins automatically
    if [[ -x "$TPM_DIR/bin/install_plugins" ]]; then
        info "Installing tmux plugins..."
        "$TPM_DIR/bin/install_plugins"
        success "Tmux plugins installed"
    fi
}

# ============================================
# Install Node.js LTS via fnm
# ============================================
install_node() {
    if command_exists fnm; then
        info "Installing Node.js LTS via fnm..."
        eval "$(fnm env --shell bash)"
        fnm install --lts
        fnm default lts-latest
        success "Node.js LTS installed"
    else
        warn "fnm not found, skipping Node.js installation"
    fi
}

# ============================================
# Backup existing file/directory
# ============================================
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        warn "Backing up existing $target to $backup"
        mv "$target" "$backup"
    elif [[ -L "$target" ]]; then
        rm "$target"  # Remove existing symlink
    fi
}

# ============================================
# Create symlinks
# ============================================
create_symlinks() {
    info "Creating symlinks..."

    # ~/.zshrc
    backup_if_exists "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
    success "Linked .zshrc"

    # ~/.config/starship.toml
    mkdir -p "$HOME/.config"
    backup_if_exists "$HOME/.config/starship.toml"
    ln -sf "$DOTFILES_DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"
    success "Linked starship.toml"

    # ~/.gitconfig.local (shared config from dotfiles)
    backup_if_exists "$HOME/.gitconfig.local"
    ln -sf "$DOTFILES_DIR/config/git/.gitconfig.local" "$HOME/.gitconfig.local"
    success "Linked .gitconfig.local"

    # ~/.config/nvim
    backup_if_exists "$HOME/.config/nvim"
    ln -sf "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    success "Linked nvim"

    # ~/.config/tmux
    mkdir -p "$HOME/.config/tmux"
    backup_if_exists "$HOME/.config/tmux/tmux.conf"
    ln -sf "$DOTFILES_DIR/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
    backup_if_exists "$HOME/.config/tmux/keybindings.conf"
    ln -sf "$DOTFILES_DIR/config/tmux/keybindings.conf" "$HOME/.config/tmux/keybindings.conf"
    success "Linked tmux config"

    # ~/.config/lazygit
    mkdir -p "$HOME/.config/lazygit"
    backup_if_exists "$HOME/.config/lazygit/config.yml"
    ln -sf "$DOTFILES_DIR/config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
    success "Linked lazygit config"
}

# ============================================
# Configure Git user
# ============================================
configure_git() {
    info "Configuring Git..."

    # Create ~/.gitconfig if it doesn't exist or doesn't have include
    if [[ ! -f "$HOME/.gitconfig" ]] || ! grep -q "include" "$HOME/.gitconfig" 2>/dev/null; then
        backup_if_exists "$HOME/.gitconfig"
        cat > "$HOME/.gitconfig" << 'EOF'
[include]
    path = ~/.gitconfig.local
EOF
        success "Created ~/.gitconfig with include"
    else
        success "~/.gitconfig already has include"
    fi

    # Configure user.name
    local current_name=$(git config --global user.name 2>/dev/null || echo "")
    if [[ -z "$current_name" ]]; then
        echo ""
        read -p "Enter your Git name: " git_name
        git config --global user.name "$git_name"
        success "Git name set to: $git_name"
    else
        success "Git name already configured: $current_name"
    fi

    # Configure user.email
    local current_email=$(git config --global user.email 2>/dev/null || echo "")
    if [[ -z "$current_email" ]]; then
        read -p "Enter your Git email: " git_email
        git config --global user.email "$git_email"
        success "Git email set to: $git_email"
    else
        success "Git email already configured: $current_email"
    fi
}

# ============================================
# Change default shell to Zsh
# ============================================
change_shell() {
    local current_shell=$(basename "$SHELL")
    if [[ "$current_shell" == "zsh" ]]; then
        success "Shell is already Zsh"
    else
        info "Changing default shell to Zsh..."
        local zsh_path=$(which zsh)
        
        # Add zsh to /etc/shells if not present
        if ! grep -q "$zsh_path" /etc/shells; then
            echo "$zsh_path" | sudo tee -a /etc/shells
        fi
        
        chsh -s "$zsh_path"
        success "Default shell changed to Zsh (restart terminal to apply)"
    fi
}

# ============================================
# Show summary
# ============================================
show_summary() {
    echo ""
    echo -e "${BOLD}${GREEN}Installation complete!${NC}"
    echo ""
    echo "What was installed:"
    echo "  - Homebrew (package manager)"
    echo "  - Zsh (shell) + plugins"
    echo "  - Starship (prompt)"
    echo "  - Tmux + TPM (plugin manager)"
    echo "  - fnm (Node version manager)"
    echo "  - Node.js LTS"
    echo "  - Git"
    echo ""
    echo "Symlinks created:"
    echo "  - ~/.zshrc -> $DOTFILES_DIR/config/zsh/.zshrc"
    echo "  - ~/.config/starship.toml -> $DOTFILES_DIR/config/starship/starship.toml"
    echo "  - ~/.config/tmux/tmux.conf -> $DOTFILES_DIR/config/tmux/tmux.conf"
    echo "  - ~/.gitconfig.local -> $DOTFILES_DIR/config/git/.gitconfig.local"
    echo ""
    echo "Files created:"
    echo "  - ~/.gitconfig (includes ~/.gitconfig.local)"
    echo ""
    echo -e "${YELLOW}Please restart your terminal to apply changes.${NC}"
}

# ============================================
# Main
# ============================================
main() {
    show_banner
    detect_os
    update_system
    install_homebrew
    install_packages
    install_zsh_plugins
    install_tpm
    install_node
    create_symlinks
    configure_git
    change_shell
    show_summary
}

main "$@"
