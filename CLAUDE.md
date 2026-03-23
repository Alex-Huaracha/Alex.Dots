# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for macOS and Linux/WSL. Manages shell, editor, terminal, and tool configurations via a single idempotent installer that uses Homebrew and symlinks.

## Installation

```bash
./install.sh
```

The installer is idempotent — it detects the OS (macOS/Linux/WSL), installs Homebrew and Brewfile packages, clones zsh plugins, installs TPM + tmux plugins, sets up Node.js via fnm, creates symlinks, configures git user info, and sets zsh as default shell. Existing files are backed up with a timestamp before symlinking.

## Architecture

### Symlink-based config management

All configs live under `config/` and get symlinked to their expected locations by `install.sh`. There are no per-config install scripts — the root `install.sh` is the sole orchestrator.

| Source | Symlink Target |
|--------|---------------|
| `config/zsh/.zshrc` | `~/.zshrc` |
| `config/starship/starship.toml` | `~/.config/starship.toml` |
| `config/git/.gitconfig.local` | `~/.gitconfig.local` |
| `config/nvim/` | `~/.config/nvim/` |
| `config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| `config/tmux/keybindings.conf` | `~/.config/tmux/keybindings.conf` |
| `config/lazygit/config.yml` | `~/.config/lazygit/config.yml` |
| `config/wezterm/wezterm.lua` | `~/.wezterm.lua` |
| `config/claude-code/settings.json` | `~/.claude/settings.json` |
| `config/claude-code/statusline.sh` | `~/.claude/statusline.sh` |

When adding a new config: add the files under `config/<tool>/`, then add the symlink creation to the `create_symlinks()` function in `install.sh`, and add any new brew packages to `Brewfile`.

### Git config split

`~/.gitconfig` (created by installer, not tracked) holds user name/email and includes `~/.gitconfig.local`. The tracked `.gitconfig.local` holds shared settings (editor, merge style, push behavior, colors). Personal info stays out of the repo.

### Neovim

Based on LazyVim. Plugin configs are in `config/nvim/lua/plugins/` (one file per concern: `editor.lua`, `ui.lua`, `colorscheme.lua`, `oil.lua`, `markdown.lua`, `disabled.lua`). Core settings are in `config/nvim/lua/config/` (`options.lua`, `keymaps.lua`, `autocmds.lua`, `lazy.lua`).

### Tmux

Uses TPM for plugin management. `tmux.conf` loads plugins first, then sources `keybindings.conf` at the end to allow overriding plugin defaults. Prefix is `Ctrl+a`.

### Zsh

Sources `~/.zshrc.local` at the end for machine-specific overrides (not tracked). Plugins (autosuggestions, syntax-highlighting) are cloned to `~/.zsh/` by the installer.

## Conventions

- **Commit messages**: Use conventional commits with scope — `feat(zsh):`, `fix(nvim):`, `refactor(tmux):`, `chore(nvim):`, `style(tmux):`. Scope is the tool/config area being changed.
- **New tool configs**: Create `config/<tool>/` directory, add symlink in `create_symlinks()`, add brew dependency in `Brewfile` if applicable.
