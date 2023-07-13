# oh-my-minimal
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPLv3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)


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
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-a411ef3-yellowgreen)](https://github.com/zsh-users/zsh-autosuggestions/commit/a411ef3e0992d4839f0732ebeb9823024afaaaa8) | [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-1386f12-yellowgreen)](https://github.com/zsh-users/zsh-syntax-highlighting/commit/1386f1213eb0b0589d73cd3cf7c56e6a972a9bfd) | [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) |
| [![pipeline status](https://img.shields.io/badge/Upsteam%20Commit-fab8c1c-yellowgreen)](https://gitlab.com/DeveloperC/zsh-simple-abbreviations/-/tree/fab8c1c3961ef042aa7e514f7f32021fbbac6ecc) | [https://gitlab.com/DeveloperC/zsh-simple-abbreviations](https://gitlab.com/DeveloperC/zsh-simple-abbreviations) |


## Installation

```sh
git clone https://gitlab.com/DeveloperC/oh-my-minimal.git ~/.oh-my-minimal
```


## Example .zshrc

```sh
# If not interactive shell, don't load anything.
if [[ ! -o interactive ]]; then
    return
fi

# Load all common setup between Bash and Zsh.
if [[ -f "${HOME}/.profile" ]]; then
    source "${HOME}/.profile"
fi

# History.
HISTFILE=${HOME}/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh#L34
# https://zsh.sourceforge.io/Doc/Release/Options.html
setopt extended_history       # Record timestamp and duration in the HISTFILE.
setopt hist_expire_dups_first # Delete duplicates first when the HISTFILE size exceeds HISTSIZE.
setopt hist_ignore_dups       # Do not record if it is a duplicate of the previous command.
setopt hist_ignore_space      # Do not record if the command starts with a space.
setopt hist_verify            # Show command with history expansion before running it.
setopt share_history          # To save every command before it is executed and to read the history file everytime history is called.

# Source extra zsh plugins.
source "${HOME}/.oh-my-minimal/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${HOME}/.oh-my-minimal/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${HOME}/.oh-my-minimal/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"

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
bindkey '\t' expand-or-complete

setopt PROMPT_SUBST # Allow functions to be called in prompt.
PROMPT=$'\n%F{blue}%n%f@%F{yellow}%M%f [%F{green}%~%f] \n%(?.%F{green}.%F{red}%? )>>>%f '

# Initialize the autocompletion.
autoload -Uz compinit && compinit

# oh-my-zsh case autocompletion ignore casing.
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

# Highlight the current autocomplete option.
zstyle ":completion:*:default" menu select

source "${HOME}/.abbreviations"
```


## Example .abbreviations
```sh
#!/usr/bin/env bash

# General
zsh-simple-abbreviations --add G "| grep"
zsh-simple-abbreviations --add S "sudo"
zsh-simple-abbreviations --add E "exit"
zsh-simple-abbreviations --add C "clear"
# Ask for confirmation if overwriting and be verbose by default.
zsh-simple-abbreviations --add MV "mv -iv"
# Ask for confirmation if overwriting, be verbose and be recursive by default.
zsh-simple-abbreviations --add CP "cp -riv"
# Create parents if they do not exist and be verbose by default.
zsh-simple-abbreviations --add MD "mkdir -vp"

# If Mac OSX
if [ "$(uname -s | grep -c "^Darwin$")" -eq 1 ]; then
    XARGS="xargs -I {}"

    # Show almost all entries, add indicators and colour.
    ENHANCED_LS="ls -F -G -h"
    zsh-simple-abbreviations --add L "${ENHANCED_LS}"
    zsh-simple-abbreviations --add LA "${ENHANCED_LS} -a"
    zsh-simple-abbreviations --add LL "${ENHANCED_LS} -l"
    zsh-simple-abbreviations --add LLA "${ENHANCED_LS} -l -a"

    # Automatically ls after cd, does not work with $ENHANCED_LS.
    cd() { builtin cd "$@" && ls -F -G -h; }

    # Clipboard
    if [ "$(command -v pbpaste)" ]; then
        zsh-simple-abbreviations --add CO "pbpaste"
    fi

    if [ "$(command -v pbcopy)" ]; then
        COPY_TO_CLIPBOARD="pbcopy"
        zsh-simple-abbreviations --add CI "| ${COPY_TO_CLIPBOARD}"
    fi

    # Open URL with browser.
    if [ "$(command -v open)" ]; then
        OPEN_URL="open"
    fi
fi

# If Linux
if [ "$(uname -s | grep -c "^Linux$")" -eq 1 ]; then
    XARGS="xargs -r -I {}"

    # Show almost all entries, add indicators and colour.
    ENHANCED_LS="ls --classify --color --human-readable"
    zsh-simple-abbreviations --add L "${ENHANCED_LS}"
    zsh-simple-abbreviations --add LA "${ENHANCED_LS} --almost-all"
    zsh-simple-abbreviations --add LL "${ENHANCED_LS} -l"
    zsh-simple-abbreviations --add LLA "${ENHANCED_LS} --almost-all -l"

    # Automatically ls after cd, does not work with $ENHANCED_LS.
    cd() { builtin cd "$@" && ls --classify --color --human-readable; }

    # Clipboard
    if [ "$(command -v xclip)" ]; then
        COPY_TO_CLIPBOARD="xclip -selection clipboard"
        zsh-simple-abbreviations --add CO "xclip -o"
        zsh-simple-abbreviations --add CI "| ${COPY_TO_CLIPBOARD}"
    fi

    # Open URL with browser.
    if [ "$(command -v xdg-open)" ]; then
        OPEN_URL="xdg-open"
    fi
fi

# Terminal Editor
if [ -n "${EDITOR}" ]; then
    zsh-simple-abbreviations --add V "${EDITOR}"
fi

# Git
if [ "$(command -v git)" ]; then

    GET_BRANCH="git branch --show-current"
    IS_IN_GIT="git rev-parse --is-inside-work-tree > /dev/null 2>&1"
    GET_HEAD_BRANCH="git branch -a | grep \"^  remotes/origin/HEAD -> origin/\" | cut -d \"/\" -f 4"

    if [ "$(command -v fzf)" ]; then
        CHOOSE_BRANCH="git branch -a | sed 's/^..//' | grep -v \"^remotes/origin/HEAD\" | sed 's/^remotes\/origin\///g' | sort | uniq | grep -v \"^\$(git branch --show-current)\$\" | fzf"

        if [ -n "${XARGS}" ]; then
            # Git switch branch.
            zsh-simple-abbreviations --add GSB "${CHOOSE_BRANCH} | ${XARGS} git switch \"{}\""
        fi

        # Git rebase on branch.
        zsh-simple-abbreviations --add GROB "git rebase \"\$(${CHOOSE_BRANCH})\""
    fi

    git_rebase="git pull --rebase --autostash"
    zsh-simple-abbreviations --add GPR "${git_rebase}"
    # Git switch master.
    zsh-simple-abbreviations --add GSM "${IS_IN_GIT} && git switch \"\$(${GET_HEAD_BRANCH})\" && ${git_rebase}"

    # Git push.
    zsh-simple-abbreviations --add GP "git push"
    zsh-simple-abbreviations --add GPF "git push --force-with-lease"

    # Git status.
    zsh-simple-abbreviations --add GS "${IS_IN_GIT} && echo '' && git --no-pager log origin/HEAD~1..\"\$(${GET_BRANCH})\" --oneline && echo '' && git status --short && echo ''"

    # Git rebase branch.
    zsh-simple-abbreviations --add GRB "git rebase -i HEAD~\$(git rev-list --count origin/\"\$(${GET_HEAD_BRANCH})\"..\"\$(${GET_BRANCH})\")"

    # Git commit ammend.
    zsh-simple-abbreviations --add GCA "git commit --amend --no-edit"

    # Git temp commit.
    zsh-simple-abbreviations --add GTC "git commit -m \"BUILD: WORKING COMMIT - DELETE\""

    # Git add all.
    zsh-simple-abbreviations --add GAA "git add -u"

    # Git push branch.
    zsh-simple-abbreviations --add GPB "git push --set-upstream origin \"\$(${GET_BRANCH})\""

    if [ -n "${OPEN_URL}" ]; then
        GET_REPOSITORY_URL="git remote get-url origin | sed 's|^git@||g' | sed 's|^https://||g' | sed 's|[.]git$||g' | sed 's|:|/|g'"

        # Git open repository.
        zsh-simple-abbreviations --add GOR "${IS_IN_GIT} && ${OPEN_URL} \"https://\$(${GET_REPOSITORY_URL})\""
        # Git open branch.
        zsh-simple-abbreviations --add GOB "${IS_IN_GIT} && BASE_URL=\$(${GET_REPOSITORY_URL}) && BRANCH=\$(${GET_BRANCH}) && if [[ \${BASE_URL} = gitlab* ]]; then ${OPEN_URL} \"https://\${BASE_URL}/tree\${BRANCH})\"; elif [[ \${BASE_URL} = github* ]]; then ${OPEN_URL} \"https://\${BASE_URL}/tree/\${BRANCH}\"; elif [[ \${BASE_URL} = bitbucket* ]]; then ${OPEN_URL} \"https://\${BASE_URL}/branch/\${BRANCH}\"; else echo \"Not GitLab/GitHub/BitBucket can not handle.\"; fi; unset BASE_URL; unset BRANCH;"
        # Git open PR.
        zsh-simple-abbreviations --add GOP "${IS_IN_GIT} && BASE_URL=\$(${GET_REPOSITORY_URL}) && BRANCH=\$(${GET_BRANCH}) && if [[ \${BASE_URL} = gitlab* ]]; then ${OPEN_URL} \"https://\${BASE_URL}/-/merge_requests/new?merge_request%5Bsource_branch%5D=\${BRANCH}\"; elif [[ \${BASE_URL} = github* ]]; then ${OPEN_URL} \"https://\${BASE_URL}/pull/new/\${BRANCH}\"; elif [[ \${BASE_URL} = bitbucket* ]]; then ${OPEN_URL} \"https://\${BASE_URL}/pull-request/new?source=\${BRANCH}\"; else echo \"Not GitLab/GitHub/BitBucket can not handle.\"; fi; unset BASE_URL; unset BRANCH;"
    fi
fi

# Docker
if [ "$(command -v docker)" ]; then
    if [ -n "${XARGS}" ]; then
        zsh-simple-abbreviations --add DRC "docker ps -a | grep -E \"(Exited|Created)\" | awk '{print \$1}' | ${XARGS} docker rm \"{}\""
        zsh-simple-abbreviations --add DRI "docker images -q | ${XARGS} docker rmi \"{}\""
        zsh-simple-abbreviations --add DKC "docker ps -q | ${XARGS} docker kill \"{}\""
    fi

    zsh-simple-abbreviations --add DP "docker ps -a"
    zsh-simple-abbreviations --add DI "docker images"
fi

# Tmux
if [ "$(command -v tmux)" ]; then
    zsh-simple-abbreviations --add T "tmux"
    zsh-simple-abbreviations --add TK "tmux kill-session"
    zsh-simple-abbreviations --add TL "tmux list-sessions"
    zsh-simple-abbreviations --add TA "tmux attach-session"
    zsh-simple-abbreviations --add TD "tmux detach"
    zsh-simple-abbreviations --add TN "tmux new-session -s"
    zsh-simple-abbreviations --add TR "tmux rename-session"
fi
```
