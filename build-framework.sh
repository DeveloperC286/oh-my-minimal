#!/usr/bin/env bash

# Ensure Git is installed.
command -v git >/dev/null 2>&1 || {
	echo >&2 "The 'git' command is not installed. Aborting."
	exit 1
}

set -o errexit
set -o nounset
set -o pipefail

# Ensure no uncommitted changes.
UNCOMMITTED=$(git diff-index HEAD)

if [ -n "${UNCOMMITTED}" ]; then
	echo "There are uncommitted changes, unable to commit upstream updates."
	exit 1
fi

# Setup folder.
INSTALLATION_DIR=$(pwd)

# Install zsh-autosuggestions
AUTOSUGGESTIONS_DIRECTORY="${INSTALLATION_DIR}/zsh-autosuggestions"
AUTOSUGGESTIONS_VERSION="0.7.1"
rm -rf "${AUTOSUGGESTIONS_DIRECTORY}"
curl -sL "https://github.com/zsh-users/zsh-autosuggestions/archive/refs/tags/v${AUTOSUGGESTIONS_VERSION}.tar.gz" | tar xz --directory "${INSTALLATION_DIR}" && mv "${AUTOSUGGESTIONS_DIRECTORY}-${AUTOSUGGESTIONS_VERSION}" "${AUTOSUGGESTIONS_DIRECTORY}"

# Clean up zsh-autosuggestions
cd "${AUTOSUGGESTIONS_DIRECTORY}"

# Deleting useless information in the repository.
rm -rf ./.git ./.circleci ./src ./spec ./.github
rm ./.rubocop.yml ./Gemfile.lock ./Gemfile ./CHANGELOG.md ./DESCRIPTION ./VERSION ./URL ./.rspec ./ZSH_VERSIONS ./.editorconfig ./Makefile ./.ruby-version ./Dockerfile ./INSTALL.md ./LICENSE ./install_test_zsh.sh ./README.md ./zsh-autosuggestions.plugin.zsh ./.gitignore

# Committing all plugin changes as a singular commit.
git add -A
git diff --staged --quiet || git commit -m "feat: zsh-autosuggestions ${AUTOSUGGESTIONS_VERSION}"

# Install zsh-syntax-highlighting
HIGHLIGHTING_DIRECTORY="${INSTALLATION_DIR}/zsh-syntax-highlighting"
rm -rf "${HIGHLIGHTING_DIRECTORY}"
HIGHLIGHTING_VERSION="0.8.0"
curl -sL "https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/tags/${HIGHLIGHTING_VERSION}.tar.gz" | tar xz --directory "${INSTALLATION_DIR}" && mv "${HIGHLIGHTING_DIRECTORY}-${HIGHLIGHTING_VERSION}" "${HIGHLIGHTING_DIRECTORY}"

# Clean up zsh-syntax-highlighting
cd "${HIGHLIGHTING_DIRECTORY}"

# Deleting useless information in the repository.
rm -rf ./.git ./docs ./tests ./images ./.github/
rm ./COPYING.md ./changelog.md ./.gitignore ./HACKING.md ./Makefile ./.gitattributes ./INSTALL.md ./.version ./.revision-hash ./README.md ./release.md ./.editorconfig ./zsh-syntax-highlighting.plugin.zsh
sed -i.bak -E '/typeset -g ZSH_HIGHLIGHT_VERSION*/d' ./zsh-syntax-highlighting.zsh
sed -i.bak -E '/typeset -g ZSH_HIGHLIGHT_REVISION*/d' ./zsh-syntax-highlighting.zsh
rm ./zsh-syntax-highlighting.zsh.bak
cd highlighters/
du | grep test-data | awk '{print $2}' | xargs -I {} rm -rf "{}"
du -a | grep README.md | awk '{print $2}' | xargs -I {} rm "{}"

# Committing all plugin changes as a singular commit.
git add -A
git diff --staged --quiet || git commit -m "feat: zsh-syntax-highlighting ${HIGHLIGHTING_VERSION}"

# Install zsh-simple-abbreviations
SIMPLE_ABBREVIATIONS_DIRECTORY="${INSTALLATION_DIR}/zsh-simple-abbreviations"
rm -rf "${SIMPLE_ABBREVIATIONS_DIRECTORY}"
SIMPLE_ABBREVIATIONS_VERSION="1.0.0"
curl -sL "https://github.com/DeveloperC286/zsh-simple-abbreviations/archive/refs/tags/v${SIMPLE_ABBREVIATIONS_VERSION}.tar.gz" | tar xz --directory "${INSTALLATION_DIR}" && mv "${SIMPLE_ABBREVIATIONS_DIRECTORY}-${SIMPLE_ABBREVIATIONS_VERSION}" "${SIMPLE_ABBREVIATIONS_DIRECTORY}"

# Clean up zsh-simple-abbreviations
cd "${SIMPLE_ABBREVIATIONS_DIRECTORY}"

# Deleting useless information in the repository.
rm -rf ./.git ./.github ./ci ./end-to-end-tests
rm ./LICENSE ./README.md ./.release-please-manifest.json ./.yamlfmt ./CHANGELOG.md ./Earthfile ./release-please-config.json

# Committing all plugin changes as a singular commit.
git add -A
git diff --staged --quiet || git commit -m "feat: zsh-simple-abbreviations ${SIMPLE_ABBREVIATIONS_VERSION}"
