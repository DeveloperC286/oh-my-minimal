# So new files are owned by the user.
UID := $(shell id -u)
GID := $(shell id -g)

.PHONY: check-clean-git-history check-conventional-commits-linting check-yaml-formatting fix-yaml-formatting check-github-actions-workflows-linting

# renovate: depName=ghcr.io/developerc286/clean_git_history
CLEAN_GIT_HISTORY_VERSION=1.0.4@sha256:5783341a3377a723e409e72b9ec0826a75ba944288d030978355de05ef65b186

check-clean-git-history:
	docker pull ghcr.io/developerc286/clean_git_history:$(CLEAN_GIT_HISTORY_VERSION)
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/developerc286/clean_git_history:$(CLEAN_GIT_HISTORY_VERSION) $(FROM)

check-conventional-commits-linting:
	docker build -t check-conventional-commits-linting -f ci/check-conventional-commits-linting.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) check-conventional-commits-linting $(FROM)

# renovate: depName=mvdan/shfmt
SHFMT_VERSION=v3.11.0-alpine@sha256:394d755b6007056a2e6d7537ccdbdcfca01b9855ba91e99df0166ca039c9d422

check-shell-formatting:
	docker pull mvdan/shfmt:$(SHFMT_VERSION)
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) mvdan/shfmt:$(SHFMT_VERSION) --simplify --diff ./ci/* 

# renovate: depName=ghcr.io/google/yamlfmt
YAMLFMT_VERSION=0.17.2@sha256:fa6874890092db69f35ece6a50e574522cae2a59b6148a1f6ac6d510e5bcf3cc

check-yaml-formatting:
	docker pull ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION)
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION) -verbose -lint -dstar .github/workflows/*

fix-shell-formatting:
	docker pull mvdan/shfmt:$(SHFMT_VERSION)
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) mvdan/shfmt:$(SHFMT_VERSION) --simplify --write ./ci/* 

fix-yaml-formatting:
	docker pull ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION)
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION) -verbose -dstar .github/workflows/*

# renovate: depName=rhysd/actionlint
ACTIONLINT_VERSION=1.7.7@sha256:887a259a5a534f3c4f36cb02dca341673c6089431057242cdc931e9f133147e9

check-github-actions-workflows-linting:
	docker pull rhysd/actionlint:$(ACTIONLINT_VERSION)
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) rhysd/actionlint:$(ACTIONLINT_VERSION) -verbose -color