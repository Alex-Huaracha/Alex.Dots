# ============================================
# Alex.Dots - Zsh Configuration
# ============================================

# ============================================
# Homebrew
# ============================================
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (Apple Silicon)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    # macOS (Intel)
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    # Linux/WSL
    if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

# ============================================
# Zsh Plugins
# ============================================
# Autosuggestions (suggests commands as you type)
if [[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Syntax highlighting (colors for valid/invalid commands)
if [[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ============================================
# fnm (Fast Node Manager)
# ============================================
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

# ============================================
# Starship Prompt
# ============================================
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# ============================================
# Environment Variables
# ============================================
export EDITOR="nvim"
export VISUAL="nvim"

# ============================================
# History Configuration
# ============================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_DUPS       # Ignore duplicate commands
setopt HIST_IGNORE_SPACE      # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS     # Remove unnecessary blanks

# ============================================
# Zsh Options
# ============================================
setopt AUTO_CD                # cd by typing directory name
setopt CORRECT                # Spell correction for commands
setopt COMPLETE_IN_WORD       # Complete from both ends of word
setopt ALWAYS_TO_END          # Move cursor to end after completion

# ============================================
# Key Bindings
# ============================================
bindkey -e                    # Emacs key bindings
bindkey '^[[A' history-search-backward  # Up arrow searches history
bindkey '^[[B' history-search-forward   # Down arrow searches history

# ============================================
# Aliases - Git
# ============================================
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# ============================================
# Aliases - General
# ============================================
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ============================================
# Aliases - Editor
# ============================================
alias v="nvim"
alias vim="nvim"

# ============================================
# Aliases - Node/npm
# ============================================
alias ni="npm install"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"

# ============================================
# Local Configuration (not tracked in git)
# ============================================
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# opencode
export PATH=/home/alex/.opencode/bin:$PATH
