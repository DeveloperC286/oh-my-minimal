#!/usr/bin/env bash

# Ensure Git is installed.
command -v git >/dev/null 2>&1 || {
	echo >&2 "The 'git' command is not installed. Aborting."
	exit 1
}

set -o errexit
set -o pipefail

# Ensure no uncommitted changes.
UNCOMMITTED=$(git diff-index HEAD)

if [ -n "${UNCOMMITTED}" ]; then
	echo "There are uncommitted changes, unable to commit upstream updates."
	exit 1
fi

# Setup folder.
INSTALLATION_DIR=$(pwd)
README_FILE="${INSTALLATION_DIR}/README.md"
START_BADGE="https://img.shields.io/badge/Upsteam%20Commit-"
END_BADGE="-yellowgreen\)\]\("

if [ ! -f $README_FILE ]; then
	echo "README.md to update with commit hashes does not exist."
	exit 1
fi

# Install zsh-autosuggestions
AUTOSUGGESTIONS_DIRECTORY="${INSTALLATION_DIR}/zsh-autosuggestions"
AUTOSUGGESTIONS_URL="https://github.com/zsh-users/zsh-autosuggestions"
rm -rf "${AUTOSUGGESTIONS_DIRECTORY}"
git clone "${AUTOSUGGESTIONS_URL}" "${AUTOSUGGESTIONS_DIRECTORY}"

# Clean up zsh-autosuggestions
if [ -d "${AUTOSUGGESTIONS_DIRECTORY}" ]; then
	cd "${AUTOSUGGESTIONS_DIRECTORY}"

	# Get repository information.
	OLD_GIT_HASH=$(grep "${AUTOSUGGESTIONS_URL}/commit/" "${README_FILE}" | cut -d '|' -f 2 | cut -d '(' -f 3 | cut -d ')' -f 1 | rev | cut -d '/' -f 1 | rev)
	BODY=$(git log --format="%h %B" "${OLD_GIT_HASH}..")
	LONG_GIT_HASH=$(git rev-parse HEAD)
	SHORT_GIT_HASH=$(git rev-parse --short HEAD)

	# Modifying repository information in the README.md.
	sed -i.bak -E "s|${START_BADGE}[0-9a-fA-F]{7}${END_BADGE}${AUTOSUGGESTIONS_URL}/commit/[0-9a-fA-F]{40}|${START_BADGE}${SHORT_GIT_HASH}${END_BADGE}${AUTOSUGGESTIONS_URL}/commit/${LONG_GIT_HASH}|" "${README_FILE}"
	rm "${README_FILE}.bak"

	# Deleting useless information in the repository.
	rm -rf ./.git ./.circleci ./src ./spec ./.github
	rm ./.rubocop.yml ./Gemfile.lock ./Gemfile ./CHANGELOG.md ./DESCRIPTION ./VERSION ./URL ./.rspec ./ZSH_VERSIONS ./.editorconfig ./Makefile ./.ruby-version ./Dockerfile ./INSTALL.md ./LICENSE ./install_test_zsh.sh ./README.md ./zsh-autosuggestions.plugin.zsh

	# Committing all plugin changes as a singular commit.
	git add -A
	git diff --staged --quiet || git commit -m "feat: applying zsh-autosuggestions updates" -m "${BODY}"
else
	echo "Unable to clone zsh-autosuggestions."
	exit 1
fi

# Install zsh-syntax-highlighting
HIGHLIGHTING_DIRECTORY="${INSTALLATION_DIR}/zsh-syntax-highlighting"
HIGHLIGHTING_URL="https://github.com/zsh-users/zsh-syntax-highlighting"
rm -rf "${HIGHLIGHTING_DIRECTORY}"
git clone "${HIGHLIGHTING_URL}" "${HIGHLIGHTING_DIRECTORY}"

# Clean up zsh-syntax-highlighting
if [ -d "${HIGHLIGHTING_DIRECTORY}" ]; then
	cd "${HIGHLIGHTING_DIRECTORY}"

	# Get repository information.
	OLD_GIT_HASH=$(grep "${HIGHLIGHTING_URL}/commit/" "${README_FILE}" | cut -d '|' -f 2 | cut -d '(' -f 3 | cut -d ')' -f 1 | rev | cut -d '/' -f 1 | rev)
	BODY=$(git log --format="%h %B" "${OLD_GIT_HASH}..")
	LONG_GIT_HASH=$(git rev-parse HEAD)
	SHORT_GIT_HASH=$(git rev-parse --short HEAD)

	# Modifying repository information in the README.md.
	sed -i.bak -E "s|${START_BADGE}[0-9a-fA-F]{7}${END_BADGE}${HIGHLIGHTING_URL}/commit/[0-9a-fA-F]{40}|${START_BADGE}${SHORT_GIT_HASH}${END_BADGE}${HIGHLIGHTING_URL}/commit/${LONG_GIT_HASH}|" "${README_FILE}"
	rm "${README_FILE}.bak"

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
	git diff --staged --quiet || git commit -m "feat: applying zsh-syntax-highlighting updates" -m "${BODY}"
else
	echo "Unable to clone zsh-syntax-highlighting."
	exit 1
fi

# Install zsh-simple-abbreviations
SIMPLE_ABBREVIATIONS_DIRECTORY="${INSTALLATION_DIR}/zsh-simple-abbreviations"
SIMPLE_ABBREVIATIONS_URL="https://gitlab.com/DeveloperC/zsh-simple-abbreviations"
rm -rf "${SIMPLE_ABBREVIATIONS_DIRECTORY}"
git clone "${SIMPLE_ABBREVIATIONS_URL}" "${SIMPLE_ABBREVIATIONS_DIRECTORY}"

# Clean up zsh-simple-abbreviations
if [ -d "${SIMPLE_ABBREVIATIONS_DIRECTORY}" ]; then
	cd "${SIMPLE_ABBREVIATIONS_DIRECTORY}"

	# Get repository information.
	OLD_GIT_HASH=$(grep "${SIMPLE_ABBREVIATIONS_URL}/-/tree/" "${README_FILE}" | cut -d '|' -f 2 | cut -d '(' -f 3 | cut -d ')' -f 1 | rev | cut -d '/' -f 1 | rev)
	BODY=$(git log --format="%h %B" "${OLD_GIT_HASH}..")
	LONG_GIT_HASH=$(git rev-parse HEAD)
	SHORT_GIT_HASH=$(git rev-parse --short HEAD)

	# Modifying repository information in the README.md.
	sed -i.bak -E "s|${START_BADGE}[0-9a-fA-F]{7}${END_BADGE}${SIMPLE_ABBREVIATIONS_URL}/-/tree/[0-9a-fA-F]{40}|${START_BADGE}${SHORT_GIT_HASH}${END_BADGE}${SIMPLE_ABBREVIATIONS_URL}/-/tree/${LONG_GIT_HASH}|" "${README_FILE}"
	rm "${README_FILE}.bak"

	# Deleting useless information in the repository.
	rm -rf ./.git
	rm ./LICENSE ./README.md ./.gitlab-ci.yml

	# Committing all plugin changes as a singular commit.
	git add -A
	git diff --staged --quiet || git commit -m "feat: applying zsh-simple-abbreviations updates" -m "${BODY}"
else
	echo "Unable to clone zsh-simple-abbreviations."
	exit 1
fi
