# oh-my-minimal


## Example .zshrc
```
# History.
setopt hist_ignore_all_dups
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Source extra zsh plugins.
source $HOME/.oh-my-minimal/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.oh-my-minimal/zsh-git-prompt/zsh-git-prompt.zsh
source $HOME/.oh-my-minimal/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.oh-my-minimal/zsh-abbrev-alias/zsh-abbrev-alias.zsh
source $HOME/.oh-my-minimal/zsh-interactive-cd/zsh-interactive-cd.zsh

# Up arrow searches history containing string.
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end

# Prompt information.
function git_prompt() {
    tester=$(git rev-parse --git-dir 2> /dev/null) || return
    echo "$(git_super_status) (`git config user.email`) "
}

PROMPT=$'%{$fg[blue]%}%n %{$reset_color%}%{$fg[green]%}[%~]%{$reset_color%} $(git_prompt) \n %{$fg[blue]%}%{$fg[blue]%}❯%{$reset_color%} '

# oh-my-zsh case autocompletion ignore casing.
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Aliases.
source $HOME/.aliases
source $HOME/.abbreviations
```
