# Alex.Dots

Personal config files for macOS and Linux/WSL. Just configs — one script to symlink them into place.

## What's included

| Tool | Description |
|------|-------------|
| Zsh | Shell config (`.zshrc`) |
| Starship | Cross-shell prompt |
| Neovim | LazyVim-based config |
| Tmux | Terminal multiplexer (prefix: `Ctrl+a`) |
| WezTerm | Terminal emulator (Linux/WSL) |
| Ghostty | Terminal emulator (macOS) |
| Lazygit | Git TUI |
| Git | Shared settings (`.gitconfig.local`) |
| Claude Code | `statusline.sh` (settings + instructions are managed by gentle-ai) |

## Usage

```bash
git clone https://github.com/<your-user>/Alex.Dots.git
cd Alex.Dots
./link.sh
```

`link.sh` symlinks every config to where its app expects it (`~/.zshrc`, `~/.config/nvim/`, etc.). It only creates symlinks — it does not install packages, plugins, or runtimes. Existing files are backed up with a timestamp before linking. It is idempotent, so you can re-run it anytime.

The tools themselves (zsh, neovim, tmux, starship, lazygit, …) you install however you like on each machine.

## Structure

```
config/
  zsh/          # .zshrc
  starship/     # starship.toml
  nvim/         # LazyVim config (plugins, keymaps, options)
  tmux/         # tmux.conf + keybindings.conf
  wezterm/      # wezterm.lua (Linux/WSL)
  ghostty/      # config (macOS)
  lazygit/      # config.yml
  git/          # .gitconfig.local
  claude-code/  # statusline.sh
link.sh         # symlinks configs into place
```

## Git config

Your name/email live in `~/.gitconfig` (untracked, per-machine). `link.sh` makes sure it includes the tracked `~/.gitconfig.local`, which holds the shared settings (editor, merge style, push behavior, colors). Personal info never enters the repo.

Set your identity once per machine:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## Adding a new config

1. Create `config/<tool>/` with your config files.
2. Add a `link` line in `create_symlinks()` in `link.sh`.
