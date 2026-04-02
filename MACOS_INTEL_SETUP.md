# macOS Intel Setup (Tier 3 / No Homebrew Bottles)

Manual binary installation for older Intel Macs (x86_64) where Homebrew compiles from source.

## Packages

| Package | Version | Source |
|---------|---------|--------|
| starship | 1.24.2 | curl installer |
| fnm | latest | GitHub release |
| fzf | 0.70.0 | git clone |
| fd | 10.3.0 | GitHub release (last Intel Mac supported) |
| lazygit | 0.60.0 | GitHub release |
| nvim | 0.12.0 | GitHub release |
| tmux | 3.6a | GitHub release (tmux-builds) |

## Install commands

### Starship
```bash
curl -sS https://starship.rs/install.sh | sh
```

### fnm
```bash
curl -fsSL https://github.com/Schniz/fnm/releases/latest/download/fnm-macos.zip -o /tmp/fnm.zip && unzip -o /tmp/fnm.zip -d /usr/local/bin && rm /tmp/fnm.zip
```

### fzf
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
```

### fd (v10.3.0 - last version with Intel Mac support)
```bash
curl -fsSL https://github.com/sharkdp/fd/releases/download/v10.3.0/fd-v10.3.0-x86_64-apple-darwin.tar.gz -o /tmp/fd.tar.gz && tar xzf /tmp/fd.tar.gz -C /tmp && cp /tmp/fd-v10.3.0-x86_64-apple-darwin/fd /usr/local/bin/ && rm -rf /tmp/fd.tar.gz /tmp/fd-v10.3.0-x86_64-apple-darwin
```

### lazygit
```bash
curl -fsSL https://github.com/jesseduffield/lazygit/releases/download/v0.60.0/lazygit_0.60.0_darwin_x86_64.tar.gz -o /tmp/lazygit.tar.gz && tar xzf /tmp/lazygit.tar.gz -C /tmp lazygit && cp /tmp/lazygit /usr/local/bin/ && rm -rf /tmp/lazygit.tar.gz /tmp/lazygit
```

### Neovim
```bash
curl -fsSL https://github.com/neovim/neovim/releases/download/v0.12.0/nvim-macos-x86_64.tar.gz -o /tmp/nvim.tar.gz && tar xzf /tmp/nvim.tar.gz -C /tmp && cp -r /tmp/nvim-macos-x86_64/* /usr/local/ && rm -rf /tmp/nvim.tar.gz /tmp/nvim-macos-x86_64
```

### tmux
```bash
curl -fsSL https://github.com/tmux/tmux-builds/releases/download/v3.6a/tmux-3.6a-macos-x86_64.tar.gz -o /tmp/tmux.tar.gz && tar xzf /tmp/tmux.tar.gz -C /tmp && cp /tmp/tmux /usr/local/bin/ && rm -rf /tmp/tmux.tar.gz /tmp/tmux
```

## Notes

- **fd v10.3.0** is the last release tested on Intel Mac. Newer versions dropped x86_64 macOS support.
- **tmux** binaries are available from [tmux/tmux-builds](https://github.com/tmux/tmux-builds).
- After installing, run `./install.sh` and choose option **2 (Skip)** to only create symlinks and configs.
