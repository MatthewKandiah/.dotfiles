HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep
bindkey -v

export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# git aliases
alias gst="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcmsg="git commit -m"
alias gl="git pull"
alias gp="git push"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"

# other aliases
alias ls="ls --color"

source ~/repos/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

FZF_ALT_C_COMMAND=""
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
