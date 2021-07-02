# oh-my-minimal
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org) [![License: AGPL v3](https://img.shields.io/badge/License-AGPLv3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)


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
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-a411ef3-yellowgreen)](https://github.com/zsh-users/zsh-autosuggestions) | [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-f0e6a8e-yellowgreen)](https://github.com/zsh-users/zsh-syntax-highlighting) | [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-b9fecab-yellowgreen)](https://github.com/momo-lab/zsh-abbrev-alias) | [https://github.com/momo-lab/zsh-abbrev-alias](https://github.com/momo-lab/zsh-abbrev-alias) |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-7bbe02e-yellowgreen)](https://github.com/changyuheng/zsh-interactive-cd) | [https://github.com/changyuheng/zsh-interactive-cd](https://github.com/changyuheng/zsh-interactive-cd) requires [fzf](https://github.com/junegunn/fzf). |


## Example .zshrc

```
# History.
setopt hist_ignore_all_dups
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Source extra zsh plugins.
source $HOME/.oh-my-minimal/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.oh-my-minimal/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.oh-my-minimal/zsh-abbrev-alias/zsh-abbrev-alias.zsh
source $HOME/.oh-my-minimal/zsh-interactive-cd/zsh-interactive-cd.zsh

# Up arrow searches history containing string.
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end

# Prompt information.
function git_prompt() {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return
    EMAIL=`git config --get user.email`
    BRANCH=`git branch --show-current`
    echo $'[Email: %F{green}'$EMAIL'%f] [Branch: %F{blue}'$BRANCH'%f]'

    if [ `git branch -a | grep "remotes/origin/$BRANCH\$" | wc -l` -eq 1 ] ; then
        echo '[%F{green}'`git rev-list origin/master..$BRANCH | wc -l`'%f ahead origin/master]  [%F{yellow}'`git rev-list origin/$BRANCH..HEAD | wc -l`'%f ahead origin]  [%F{red}'`git rev-list HEAD..origin/$BRANCH | wc -l`'%f behind origin]'
    else
        echo '[%F{red}Branch not pushed.%f]'
    fi

    echo ' '
}

setopt PROMPT_SUBST # Allow functions to be called in prompt.
#PROMPT=$'%n [%~]\n > '
PROMPT=$'\n%F{blue}%n%f [%F{green}%~%f] \n$(git_prompt) %F{green}>%f '

# oh-my-zsh case autocompletion ignore casing.
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Aliases.
source $HOME/.aliases
source $HOME/.abbreviations
```
