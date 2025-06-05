HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep
bindkey -v

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/code/vulkansdk_1.4.313.0/x86_64/bin:$PATH

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

source ~/code/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/code/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/code/vulkansdk_1.4.313.0/setup-env.sh

FZF_ALT_C_COMMAND=""
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
