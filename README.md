# oh-my-minimal
oh-my-minimal is a collection of plugins and documentation to help you create an awesome terminal experience with Zsh.


Some of the best plugin for Zsh are already included inside this repository with all redundant files removed to create a minimal install size.
Simply clone this repository and then source the plugin inside this repository.
An example .zshrc is provided at the bottom.


## Build yourself
If you do not trust me or want an update from one of the plugins I have not pushed yet.
You can use the script `build-framework.sh` included in this repository to download all the plugins into a new folder, the script also automatically deletes files like README's etc to take up minimal space.


## 3rd Party Additional Plugins
|                                                                                                                                           | |
|-------------------------------------------------------------------------------------------------------------------------------------------|-|
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-ae315de-yellowgreen)](https://github.com/zsh-users/zsh-autosuggestions) | [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-62c5575-yellowgreen)](https://github.com/zsh-users/zsh-syntax-highlighting) | [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-ae2997e-yellowgreen)](https://github.com/momo-lab/zsh-abbrev-alias) | [https://github.com/momo-lab/zsh-abbrev-alias](https://github.com/momo-lab/zsh-abbrev-alias) |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-0a6c8b6-yellowgreen)](https://github.com/olivierverdier/zsh-git-prompt) | [https://github.com/olivierverdier/zsh-git-prompt](https://github.com/olivierverdier/zsh-git-prompt) requires Python. |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-1cfccb9-yellowgreen)](https://github.com/changyuheng/zsh-interactive-cd) | [https://github.com/changyuheng/zsh-interactive-cd](https://github.com/changyuheng/zsh-interactive-cd) requires [fzf](https://github.com/junegunn/fzf). |


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
