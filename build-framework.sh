#!/bin/bash

# Ensure Git is installed.
command -v git >/dev/null 2>&1 || { echo >&2 "The 'git' command is not installed. Aborting."; exit 1; }

# Setup folder.
INSTALLATION_DIRECTORY=$HOME"/zsh-plugins"
rm -rf $INSTALLATION_DIRECTORY
mkdir -p $INSTALLATION_DIRECTORY

if [ -d $INSTALLATION_DIRECTORY ]; then
    cd $INSTALLATION_DIRECTORY

    # Install zsh-autosuggestions
    AUTOSUGGESTIONS_DIRECTORY=$INSTALLATION_DIRECTORY/zsh-autosuggestions
    git clone git://github.com/zsh-users/zsh-autosuggestions $AUTOSUGGESTIONS_DIRECTORY

    # Clean up zsh-autosuggestions
    if [ -d $AUTOSUGGESTIONS_DIRECTORY ]; then
        cd $AUTOSUGGESTIONS_DIRECTORY
        rm -rf ./.git ./.circleci ./src ./spec ./.github
        rm ./.rubocop.yml ./Gemfile.lock ./Gemfile ./CHANGELOG.md ./DESCRIPTION ./VERSION ./URL ./.rspec ./ZSH_VERSIONS ./.editorconfig ./Makefile ./.ruby-version ./Dockerfile ./INSTALL.md ./LICENSE ./install_test_zsh.sh ./README.md ./zsh-autosuggestions.plugin.zsh
    else
        echo "Unable to clone zsh-autosuggestions."
        exit 1
    fi

    # Install zsh-syntax-highlighting
    HIGHLIGHTING_DIRECTORY=$INSTALLATION_DIRECTORY/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HIGHLIGHTING_DIRECTORY

    # Clean up zsh-syntax-highlighting
    if [ -d $HIGHLIGHTING_DIRECTORY ]; then
        cd $HIGHLIGHTING_DIRECTORY
        rm -rf ./.git ./docs ./tests ./images
        rm ./COPYING.md ./changelog.md ./.travis.yml ./.gitignore ./HACKING.md ./Makefile ./.gitattributes ./INSTALL.md ./.version ./.revision-hash ./README.md ./release.md ./.editorconfig ./zsh-syntax-highlighting.plugin.zsh
        sed -i.bak -E '/typeset -g ZSH_HIGHLIGHT_VERSION*/d' ./zsh-syntax-highlighting.zsh
        sed -i.bak -E '/typeset -g ZSH_HIGHLIGHT_REVISION*/d' ./zsh-syntax-highlighting.zsh
        rm ./zsh-syntax-highlighting.zsh.bak
        cd highlighters/
        du | grep test-data | awk '{print $2}' | xargs -I {} rm -rf "{}"
        du -a | grep README.md | awk '{print $2}' | xargs -I {} rm "{}"
    else
        echo "Unable to clone zsh-syntax-highlighting."
        exit 1
    fi

    # Install zsh-abbrev-alias
    ABBREV_DIRECTORY=$INSTALLATION_DIRECTORY/zsh-abbrev-alias
    git clone https://github.com/momo-lab/zsh-abbrev-alias $ABBREV_DIRECTORY

    # Clean up zsh-abbrev-alias
    if [ -d $ABBREV_DIRECTORY ]; then
        cd $ABBREV_DIRECTORY
        rm -rf ./.git
		rm ./LICENSE ./README.md
        mv abbrev-alias.plugin.zsh zsh-abbrev-alias.zsh
    else
        echo "Unable to clone zsh-abbrev-alias."
        exit 1
    fi

    # Install zsh-git-prompt
    PROMPT_DIRECTORY=$INSTALLATION_DIRECTORY/zsh-git-prompt
    git clone git@github.com:olivierverdier/zsh-git-prompt.git $PROMPT_DIRECTORY

    if [ -d $PROMPT_DIRECTORY ]; then
        cd $PROMPT_DIRECTORY
        rm -rf ./.git ./src
        rm ./stack.yaml ./screenshot.png ./README.md ./LICENSE.md ./.travis.yml ./.gitignore ./Setup.hs
        mv zshrc.sh zsh-git-prompt.zsh
    else
        echo "Unable to clone zsh-git-prompt."
        exit 1
    fi
fi
