# Dotfiles validation tests
# Run: just test (both), just test-ubuntu, just test-fedora

# Test config
test_email := "test@example.com"
test_signingkey := "/root/.ssh/id_test"
branch := "refresh"
repo := "https://github.com/asksven/dotfiles.git"

# Run all tests
test: test-ubuntu test-fedora
    @echo "All tests passed."

# Test chezmoi apply on Ubuntu 24.04
test-ubuntu:
    @echo "=== Testing on Ubuntu 24.04 ==="
    docker run --rm \
      -v "{{justfile_directory()}}/test/validate.sh:/tmp/validate.sh:ro" \
      ubuntu:24.04 bash -c '\
        set -euo pipefail && \
        apt-get update -qq > /dev/null 2>&1 && \
        apt-get install -y -qq curl git sudo > /dev/null 2>&1 && \
        mkdir -p ~/.config/chezmoi && \
        printf "[data]\n    email = \"{{test_email}}\"\n    signingkey = \"{{test_signingkey}}\"\n" > ~/.config/chezmoi/chezmoi.toml && \
        sh -c "$$(curl -fsLS get.chezmoi.io)" -- init --apply --branch {{branch}} {{repo}} 2>&1 && \
        bash /tmp/validate.sh "{{test_email}}" "{{test_signingkey}}"'

# Test chezmoi apply on Fedora 41
test-fedora:
    @echo "=== Testing on Fedora 41 ==="
    docker run --rm \
      -v "{{justfile_directory()}}/test/validate.sh:/tmp/validate.sh:ro" \
      fedora:41 bash -c '\
        set -euo pipefail && \
        dnf install -y -q curl git sudo > /dev/null 2>&1 && \
        mkdir -p ~/.config/chezmoi && \
        printf "[data]\n    email = \"{{test_email}}\"\n    signingkey = \"{{test_signingkey}}\"\n" > ~/.config/chezmoi/chezmoi.toml && \
        sh -c "$$(curl -fsLS get.chezmoi.io)" -- init --apply --branch {{branch}} {{repo}} 2>&1 && \
        bash /tmp/validate.sh "{{test_email}}" "{{test_signingkey}}"'
