# Alex.Dots

Personal dotfiles for macOS and Linux/WSL.

## What's Included

- **Zsh** - Shell with plugins (autosuggestions, syntax-highlighting)
- **Starship** - Minimal, fast prompt
- **fnm** - Fast Node Manager
- **Git** - Version control configuration

## Quick Start

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/Alex.Dots.git ~/.dotfiles

# Run the installer
cd ~/.dotfiles
./install.sh
```

## What the Installer Does

1. Detects your OS (macOS, Linux, or WSL)
2. Updates system packages (Linux/WSL only)
3. Installs Homebrew (if not present)
4. Installs packages from `Brewfile`
5. Installs Zsh plugins
6. Installs Node.js LTS via fnm
7. Creates symlinks for all configs
8. Configures Git (asks for name/email)
9. Changes default shell to Zsh

## Structure

```
Alex.Dots/
├── install.sh                # Main installer (orchestrator)
├── Brewfile                  # Homebrew packages
├── scripts/
│   └── utils.sh              # Shared functions
├── config/
│   ├── zsh/
│   │   ├── .zshrc            # Zsh configuration
│   │   └── install.sh        # Zsh installer
│   ├── starship/
│   │   ├── starship.toml     # Prompt configuration
│   │   └── install.sh        # Starship installer
│   ├── git/
│   │   ├── .gitconfig.local  # Git configuration (shared)
│   │   └── install.sh        # Git installer
│   └── node/
│       └── install.sh        # Node.js installer
└── README.md
```

Each config has its own `install.sh` that can be run independently.

## Symlinks Created

| Source | Destination |
|--------|-------------|
| `config/zsh/.zshrc` | `~/.zshrc` |
| `config/starship/starship.toml` | `~/.config/starship.toml` |
| `config/git/.gitconfig.local` | `~/.gitconfig.local` |

## Git Configuration

The installer creates `~/.gitconfig` with your name/email and includes the shared config:

```gitconfig
[user]
    name = Your Name
    email = your@email.com

[include]
    path = ~/.gitconfig.local
```

This way your personal info stays out of the repo.

## Local Overrides

Add machine-specific config to `~/.zshrc.local` (not tracked in git).

## Updating

```bash
cd ~/.dotfiles
git pull
```

The symlinks will automatically point to the updated files.

## Aliases

### Node/npm
| Alias | Command |
|-------|---------|
| `ni` | `npm install` |
| `nr` | `npm run` |
| `nrd` | `npm run dev` |
| `nrb` | `npm run build` |

### General
| Alias | Command |
|-------|---------|
| `v` | `nvim` |
| `ll` | `ls -la` |
| `..` | `cd ..` |

## Requirements

- macOS, Linux, or WSL
- `curl` (for Homebrew installation)
- `git` (will be installed if missing)

## License

MIT
