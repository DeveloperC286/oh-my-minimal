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
# If not interactive shell, don't load anything.
if [[ ! -o interactive ]]; then
    return
fi

# Load all common setup between Bash and Zsh.
if [[ -f "$HOME/.profile" ]]; then
    source "$HOME/.profile"
fi

# History.
setopt hist_ignore_all_dups
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Source extra zsh plugins.
source "$HOME/.oh-my-minimal/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.oh-my-minimal/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.oh-my-minimal/zsh-abbrev-alias/zsh-abbrev-alias.zsh"
source "$HOME/.oh-my-minimal/zsh-interactive-cd/zsh-interactive-cd.zsh"

# Up arrow key searches history backwards from cursor, do not move cursor.
autoload -U history-beginning-search-backward
bindkey "^[[A" history-beginning-search-backward
# Down arrow key searches history forwards from cursor, do not move cursor.
autoload -U history-beginning-search-forward
bindkey "^[[B" history-beginning-search-forward

# Control + A/E jumps to start/end of line.
bindkey "^A" end-of-line
bindkey "^E" beginning-of-line

# Control + W jumps forward word.
bindkey "^W" vi-forward-word

# Tab does autocompletion suggestions.
bindkey '\t' zic-completion

setopt PROMPT_SUBST # Allow functions to be called in prompt.
PROMPT=$'\n%F{blue}%n%f@%F{yellow}%M%f [%F{green}%~%f] \n%(?.%F{green}.%F{red}%? )>>>%f '

# Initialize the autocompletion
autoload -U compinit; compinit

# oh-my-zsh case autocompletion ignore casing.
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

source "$HOME/.aliases"
source "$HOME/.abbreviations"
```


## Example .aliases
```
#!/bin/sh

# Enable colour support of ls by default.
# If Mac OSX
if [ "$(uname -s | grep -c "^Darwin$")" -eq 1 ]; then
		alias ls='ls -GFAh'
		alias ll='ls -GFAhl'
fi

# If Linux
if [ "$(uname -s | grep -c "^Linux$")" -eq 1 ]; then
		alias ls='ls -F --color -Ah'
		alias ll='ls -F --color -Ahl'
fi

# Enable colour support of grep by default.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Ask for confirmation if overwriting and be verbose by default.
alias mv="mv -iv"

# Ask for confirmation if overwriting, be verbose and be recursive by default.
alias cp="cp -riv"

# Create parents if they do not exist and be verbose by default.
alias mkdir="mkdir -vp"

# Automatically ls after cd.
cd() { builtin cd "$@" && ls; }
```


## Example .abbreviations
```
#!/bin/bash

# General
abbrev-alias -g G="| grep"
abbrev-alias -g S="sudo"
abbrev-alias -g C="clear"
abbrev-alias -g E="exit"

# If Mac OSX
if [ "$(uname -s | grep -c "^Darwin$")" -eq 1 ]; then
    XARGS="xargs -I {}"

    # Clipboard
    if [ "$(command -v pbpaste)" ]; then
        abbrev-alias -g CO="pbpaste"
    fi

    if [ "$(command -v pbcopy)" ]; then
        COPY_TO_CLIPBOARD="pbcopy"
        abbrev-alias -g CI="| $COPY_TO_CLIPBOARD"
    fi

    # Open URL with browser.
    if [ "$(command -v open)" ]; then
        OPEN_URL="open"
    fi
fi

# If Linux
if [ "$(uname -s | grep -c "^Linux$")" -eq 1 ]; then
    XARGS="xargs -r -I {}"

    # Clipboard
    if [ "$(command -v xclip)" ]; then
        COPY_TO_CLIPBOARD="xclip -selection clipboard"
        abbrev-alias -g CO="xclip -o"
        abbrev-alias -g CI="| $COPY_TO_CLIPBOARD"
    fi

    # Open URL with browser.
    if [ "$(command -v xdg-open)" ]; then
        OPEN_URL="xdg-open"
    fi
fi

# Terminal Editor
if [ -n "$EDITOR" ]; then
    abbrev-alias -g V="$EDITOR"
fi

# Git
if [ "$(command -v git)" ]; then
    if [ "$(command -v fzf)" ]; then
        if [ -n "$XARGS" ]; then
            abbrev-alias -g GCC="git log --oneline | fzf |  cut -d ' ' -f 1 | $XARGS git checkout \"{}\"" # git checkout commit
            abbrev-alias -g GCB="git branch -a | grep -v \"^  remotes/origin/HEAD\" | grep -v \"^* \" | sort | uniq | fzf | sed 's/^..//' | cut -d' ' -f1 | sed 's/remotes\/origin\///g' | $XARGS git checkout \"{}\"" # git checkout branch
        fi
    fi

    GET_BRANCH="git branch --show-current"
    GET_HEAD_BRANCH="git branch -a | grep \"^  remotes/origin/HEAD -> origin/\" | cut -d \"/\" -f 4"

    abbrev-alias -g GCM="git rev-parse --is-inside-work-tree > /dev/null 2>&1 && git checkout \"\$($GET_HEAD_BRANCH)\" && git pull && git reset --hard \"origin/\$($GET_HEAD_BRANCH)\"" # git checkout master, using reset as pull kept messing up.
    abbrev-alias -g GR="git reset --hard HEAD" # git reset
    abbrev-alias -g GP="git push"
    abbrev-alias -g GPR="git pull --rebase --autostash" # git pull rebase
    abbrev-alias -g GS="git rev-parse --is-inside-work-tree > /dev/null 2>&1 && echo '' && git log origin/HEAD~1..\"\$($GET_BRANCH)\" --oneline && echo '' && git status --short && echo ''" # git status
    abbrev-alias -g GSC="git stash" # git stash content
    abbrev-alias -g GSCP="git stash pop" # git stash content pop
    abbrev-alias -g GSCL="git stash list" # git stash content list
    abbrev-alias -g GD="git diff"
    abbrev-alias -g GF="git fetch -p"
	abbrev-alias -g GRM="git rebase \"\$($GET_HEAD_BRANCH)\""
    abbrev-alias -g GRC="git rebase --continue" #git rebase continue
    abbrev-alias -g GRU="git clean -f && git clean -fd && git clean -fX" #git remove uncommited
    abbrev-alias -g GGH="git rev-parse --short HEAD" #Git get hash
    abbrev-alias -g GGFC="git log --format=format: --name-only --since=12.month | egrep -v '^$' | sort | uniq -c | sort -nr" #Git get frequency changed
    abbrev-alias -g GRA="git commit --amend --reset-author --no-edit" # Git reset author
    abbrev-alias -g GCA="git commit --amend --no-edit"  # Git commit ammend
    abbrev-alias -g GAA="git add -u" # Git add all
    abbrev-alias -g GPB="git push --set-upstream origin \"\$($GET_BRANCH)\"" #Git push branch
    abbrev-alias -g GUS="git submodule update --init --recursive" #Git update submodules

    if [ -n "$OPEN_URL" ]; then
        GET_REPOSITORY_URL="git remote get-url origin | cut -d '@' -f 2 | rev | cut -d '.' -f 2- | rev | sed 's/:/\//g'"
		abbrev-alias -g GOR="REMOTE=\"https://\`$GET_REPOSITORY_URL\`\" && $OPEN_URL \"\$REMOTE\"" #git open repository
        abbrev-alias -g GOB="REMOTE=\"https://\`$GET_REPOSITORY_URL\`/tree/\`$GET_BRANCH\`\" && $OPEN_URL \"\$REMOTE\"" #git open branch
        abbrev-alias -g GOP="REMOTE=\"https://\`$GET_REPOSITORY_URL\`\" && if [[ \$REMOTE = gitlab* ]]; then $OPEN_URL \"\$REMOTE/-/merge_requests/new?merge_request%5Bsource_branch%5D=\`$GET_BRANCH\`\"; elif [[ \$REMOTE = github* ]]; then $OPEN_URL \"\$REMOTE/pull/new/\`$GET_BRANCH\`\"; else echo \"Not GitLab/GitHub can not handle.\"; fi" #git open pr
    fi
fi
```
