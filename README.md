# Alex.Dots

Personal dotfiles for macOS and Linux/WSL. One installer, symlinks, done.

## What's included

| Tool | Description |
|------|-------------|
| Zsh | Shell + autosuggestions + syntax-highlighting |
| Starship | Cross-shell prompt |
| Neovim | LazyVim-based config |
| Tmux | Terminal multiplexer (prefix: `Ctrl+a`) |
| WezTerm | Terminal emulator (WSL only) |
| Lazygit | Git TUI |
| fnm | Node.js version manager |
| Claude Code | AI assistant config |

## Prerequisites

- **Git** installed
- **Homebrew** (optional — the installer can set it up, or you can install packages manually)
- On older Intel Macs without Homebrew bottles, see [MACOS_INTEL_SETUP.md](MACOS_INTEL_SETUP.md) for direct binary installs

## Installation

```bash
git clone https://github.com/<your-user>/Alex.Dots.git
cd Alex.Dots
./install.sh
```

The installer will ask if you want to install packages via Homebrew or skip and only create symlinks/configs.

## Structure

```
config/
  zsh/          # .zshrc (aliases, history, plugins)
  starship/     # starship.toml (prompt theme)
  nvim/         # LazyVim config (plugins, keymaps, options)
  tmux/         # tmux.conf + keybindings.conf
  wezterm/      # wezterm.lua (WSL only)
  lazygit/      # config.yml
  git/          # .gitconfig.local (shared git settings)
  claude-code/  # settings.json, statusline.sh, CLAUDE.md
Brewfile        # Homebrew packages
install.sh      # Idempotent installer
```

All configs get symlinked to their expected locations (`~/.zshrc`, `~/.config/nvim/`, etc.). Existing files are backed up with a timestamp before symlinking.

## Git config

`~/.gitconfig` is created by the installer (not tracked) and holds your name/email. It includes `~/.gitconfig.local` which is the tracked file with shared settings (editor, merge style, push behavior, colors).

If you already have a `~/.gitconfig`, the installer will back it up and create a new one with the include. On first run it will ask for your name and email.

## Adding a new config

1. Create `config/<tool>/` with your config files
2. Add the symlink in `create_symlinks()` in `install.sh`
3. Add brew dependencies to `Brewfile` if applicable
