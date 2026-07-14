# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal config repository for macOS and Linux/WSL. It holds shell, editor, terminal, and tool configs — nothing else. A single script (`link.sh`) symlinks them into place. It does not install packages, plugins, or runtimes; provisioning each machine is done by hand.

## Setup

```bash
./link.sh
```

`link.sh` detects the OS (macOS/Linux/WSL) and creates every symlink, backing up any existing real file with a timestamp first. It is idempotent — safe to re-run. It also ensures `~/.gitconfig` includes the tracked `~/.gitconfig.local`. That is all it does.

## Architecture

### Symlink-based config management

All configs live under `config/` and get symlinked to their expected locations by `link.sh`. There are no per-config scripts — `link.sh` is the sole entry point.

| Source | Symlink Target |
|--------|---------------|
| `config/zsh/.zshrc` | `~/.zshrc` |
| `config/starship/starship.toml` | `~/.config/starship.toml` |
| `config/git/.gitconfig.local` | `~/.gitconfig.local` |
| `config/nvim/` | `~/.config/nvim/` |
| `config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| `config/tmux/keybindings.conf` | `~/.config/tmux/keybindings.conf` |
| `config/lazygit/config.yml` | `~/.config/lazygit/config.yml` (macOS: `~/Library/Application Support/lazygit/config.yml`) |
| `config/ghostty/config` | `~/.config/ghostty/config` (macOS only) |
| `config/wezterm/wezterm.lua` | `~/.wezterm.lua` (non-macOS only) |
| `config/claude-code/settings.json` | `~/.claude/settings.json` |
| `config/claude-code/statusline.sh` | `~/.claude/statusline.sh` |
| `config/claude-code/CLAUDE.md` | `~/.claude/CLAUDE.md` |

When adding a new config: add the files under `config/<tool>/`, then add a `link` line to the `create_symlinks()` function in `link.sh`.

### Git config split

`~/.gitconfig` (not tracked) holds user name/email and includes `~/.gitconfig.local`. The tracked `.gitconfig.local` holds shared settings (editor, merge style, push behavior, colors). Personal info stays out of the repo. Set your identity per machine with `git config --global user.name/user.email`.

### Neovim

Based on LazyVim. Plugin configs are in `config/nvim/lua/plugins/` (one file per concern: `editor.lua`, `ui.lua`, `colorscheme.lua`, `oil.lua`, `markdown.lua`, `disabled.lua`). Core settings are in `config/nvim/lua/config/` (`options.lua`, `keymaps.lua`, `autocmds.lua`, `lazy.lua`).

### Tmux

Uses TPM for plugin management. `tmux.conf` loads plugins first, then sources `keybindings.conf` at the end to allow overriding plugin defaults. Prefix is `Ctrl+a`. TPM and plugins are installed manually (not by `link.sh`).

### Zsh

Sources `~/.zshrc.local` at the end for machine-specific overrides (not tracked). Plugins (autosuggestions, syntax-highlighting) are expected under `~/.zsh/` and installed manually.

## Conventions

- **Commit messages**: Use conventional commits with scope — `feat(zsh):`, `fix(nvim):`, `refactor(tmux):`, `chore(nvim):`, `style(tmux):`. Scope is the tool/config area being changed.
- **New tool configs**: Create `config/<tool>/` directory, then add a `link` line in `create_symlinks()` in `link.sh`.
