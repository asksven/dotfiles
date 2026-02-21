#!/bin/bash
# Validation test for chezmoi dotfiles deployment
# Usage: test.sh <email> <signingkey>
set -euo pipefail

EMAIL="${1:?Usage: test.sh <email> <signingkey>}"
SIGNINGKEY="${2:?Usage: test.sh <email> <signingkey>}"

FAIL=0

assert() {
  local got="$1" expected="$2" label="$3"
  if [ "$got" != "$expected" ]; then
    echo "FAIL: $label (expected=$expected got=$got)"
    FAIL=1
  else
    echo "OK: $label"
  fi
}

assert_file() {
  if [ -f "$1" ]; then
    echo "OK: $1 exists"
  else
    echo "FAIL: $1 missing"
    FAIL=1
  fi
}

assert_exec() {
  if [ -x "$1" ]; then
    echo "OK: $1 executable"
  else
    echo "FAIL: $1 not executable"
    FAIL=1
  fi
}

assert_contains() {
  if grep -q "$2" "$1" 2>/dev/null; then
    echo "OK: $1 contains $2"
  else
    echo "FAIL: $1 missing $2"
    FAIL=1
  fi
}

echo "-- Dotfiles --"
assert_file ~/.gitconfig
assert_file ~/.alias
assert_file ~/.tmux.conf
assert_file ~/.bashrc
assert_file ~/.config/starship.toml

echo "-- Template values --"
assert_contains ~/.gitconfig "$EMAIL"
assert_contains ~/.gitconfig "$SIGNINGKEY"
assert_contains ~/.gitconfig "Sven Knispel"

echo "-- Bashrc OS branch --"
assert_contains ~/.bashrc "GPG_TTY"
assert_contains ~/.bashrc ".local/bin"

echo "-- Binaries --"
assert_exec ~/.local/bin/kubectl
assert_exec ~/.local/bin/helm
assert_exec ~/.local/bin/starship
assert_exec ~/.local/bin/just
assert_exec ~/.local/bin/yq

echo "-- Binary versions --"
YQ_VER="$(~/.local/bin/yq --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
assert "$YQ_VER" "4.44.3" "yq version"

echo "-- Chezmoi state --"
MANAGED="$(~/.local/bin/chezmoi managed | wc -l | tr -d ' ')"
if [ "$MANAGED" -ge 5 ]; then
  echo "OK: $MANAGED managed files"
else
  echo "FAIL: only $MANAGED managed files"
  FAIL=1
fi

if [ "$FAIL" -ne 0 ]; then
  echo "FAILED"
  exit 1
fi
echo "All assertions passed."
