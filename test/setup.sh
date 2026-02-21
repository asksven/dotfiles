#!/bin/bash
# Setup script for testing chezmoi in containers
# Usage: setup.sh <email> <signingkey> <branch> <repo>
set -euo pipefail

EMAIL="${1:?Usage: setup.sh <email> <signingkey> <branch> <repo>}"
SIGNINGKEY="${2:?}"
BRANCH="${3:?}"
REPO="${4:?}"

# Pre-seed chezmoi config
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<EOF
[data]
    email = "$EMAIL"
    signingkey = "$SIGNINGKEY"
EOF

# Install chezmoi and apply (into ~/.local/bin)
mkdir -p ~/.local/bin
curl -fsLS get.chezmoi.io | sh -s -- -b ~/.local/bin init --apply --branch "$BRANCH" "$REPO"
