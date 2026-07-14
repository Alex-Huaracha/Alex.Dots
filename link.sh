#!/bin/bash

# ============================================
# Alex.Dots - Symlink configs into place
# ============================================
# Links every config in this repo to where its app expects it.
# Idempotent: existing files are backed up with a timestamp first.
# Usage: ./link.sh
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ============================================
# Where this repo lives
# ============================================
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================
# Detect OS (paths differ across platforms)
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
# Back up a real file/dir, or remove a stale symlink
# ============================================
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        warn "Backing up $target -> $backup"
        mv "$target" "$backup"
    elif [[ -L "$target" ]]; then
        rm "$target"
    fi
}

# ============================================
# Link a source in this repo to a target path
# ============================================
link() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    backup_if_exists "$dst"
    ln -sf "$src" "$dst"
    success "Linked $(basename "$dst")"
}

# ============================================
# Create all symlinks
# ============================================
create_symlinks() {
    info "Linking configs..."

    link "$DOTFILES_DIR/config/zsh/.zshrc"                  "$HOME/.zshrc"
    link "$DOTFILES_DIR/config/starship/starship.toml"      "$HOME/.config/starship.toml"
    link "$DOTFILES_DIR/config/git/.gitconfig.local"        "$HOME/.gitconfig.local"
    link "$DOTFILES_DIR/config/nvim"                        "$HOME/.config/nvim"
    link "$DOTFILES_DIR/config/tmux/tmux.conf"              "$HOME/.config/tmux/tmux.conf"
    link "$DOTFILES_DIR/config/tmux/keybindings.conf"       "$HOME/.config/tmux/keybindings.conf"

    # lazygit uses a different path on macOS
    if [[ "$OS" == "macos" ]]; then
        link "$DOTFILES_DIR/config/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
    else
        link "$DOTFILES_DIR/config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
    fi

    # ghostty: macOS only
    if [[ "$OS" == "macos" ]]; then
        link "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"
    fi

    # wezterm: Windows/WSL/Linux only
    if [[ "$OS" != "macos" ]]; then
        link "$DOTFILES_DIR/config/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
    fi

    # Claude Code
    link "$DOTFILES_DIR/config/claude-code/settings.json"  "$HOME/.claude/settings.json"
    link "$DOTFILES_DIR/config/claude-code/statusline.sh"  "$HOME/.claude/statusline.sh"
    link "$DOTFILES_DIR/config/claude-code/CLAUDE.md"      "$HOME/.claude/CLAUDE.md"
}

# ============================================
# Make sure ~/.gitconfig pulls in the tracked .gitconfig.local
# (your name/email stay in ~/.gitconfig, untracked)
# ============================================
link_git_include() {
    if [[ ! -f "$HOME/.gitconfig" ]] || ! grep -q "gitconfig.local" "$HOME/.gitconfig" 2>/dev/null; then
        printf '[include]\n    path = ~/.gitconfig.local\n' >> "$HOME/.gitconfig"
        success "Added .gitconfig.local include to ~/.gitconfig"
    else
        success "~/.gitconfig already includes .gitconfig.local"
    fi
}

main() {
    detect_os
    create_symlinks
    link_git_include
    echo ""
    success "Done. Restart your terminal to apply."
}

main "$@"
