# My dotfiles

Managed with [chezmoi](https://chezmoi.io/).

## Bootstrap a new machine

### One-liner

Install chezmoi and apply dotfiles in one command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --branch <branch> asksven
```

This does three things:
1. Downloads and installs the `chezmoi` binary
2. Clones `github.com/asksven/dotfiles.git` (the specified branch) to `~/.local/share/chezmoi`
3. Applies all dotfiles, templates, and install scripts

> **Note:** `asksven` is shorthand — chezmoi expands it to `https://github.com/asksven/dotfiles.git`. Always specify `--branch` because the default branch (`master`) still has the legacy setup (liquidprompt).  Use `refresh` until that branch is merged to `master`.

### If chezmoi is already installed

```bash
chezmoi init --apply --branch refresh git@github.com:asksven/dotfiles.git
```

### Using a specific tag or branch

To bootstrap from a tag or any other branch:

```bash
# From a tag
chezmoi init --apply --branch v1.0.0 git@github.com:asksven/dotfiles.git

# From a branch
chezmoi init --apply --branch mybranch git@github.com:asksven/dotfiles.git
```

### First-run prompts

On the first run, chezmoi will prompt for:
- **email** — used in `.gitconfig`
- **signingkey** — path to your GPG or SSH signing key

These values are stored in `~/.config/chezmoi/chezmoi.toml` and reused on subsequent runs.

### Clean up a failed or stale bootstrap

If you ran `chezmoi init` before (e.g. without `--branch`), the cached repo may still point to the wrong branch. Reset everything first:

```bash
rm -rf ~/.local/share/chezmoi   # remove cached source repo
rm -rf ~/.config/chezmoi         # remove config (will re-prompt)
rm -f ~/.bashrc ~/.liquidpromptrc ~/.alias ~/.gitconfig ~/.tmux.conf
rm -f ~/bin/chezmoi              # remove chezmoi if installed to ~/bin
```

Then re-run the one-liner with `--branch`.

## Daily usage

```bash
chezmoi update -v    # Pull and apply latest changes
chezmoi add <file>   # Add a new dotfile
chezmoi edit <file>  # Edit a managed dotfile
chezmoi diff         # See pending changes
chezmoi apply -v     # Apply changes
```

## Adding packages

This repo includes a Copilot skill (`/package-advisor`) that helps pick the right install method for any tool — brew, apt, dnf, or GitHub binary — based on the current OS, arch, and distro.

### Add a new tool

In Copilot chat, type:

```
/package-advisor add k9s
```

The skill will:
1. Detect your platform (e.g. macOS/arm64, Ubuntu/amd64, Fedora/arm64)
2. Search the web for package availability
3. Recommend brew, apt/dnf, or GitHub binary
4. Edit `packages.yaml` and install scripts after you confirm

### Review existing packages

```
/package-advisor review packages.yaml
```

Audits the `binaries` section to check if any could move to a package manager on your current platform.

## SSH keys

Managed via NextCloud (see old instructions below for reference).

<details>
<summary>Legacy: SSH via NextCloud</summary>

Requires the NextCloud sync client to be installed and sync to be finished.

1. Check your local .ssh and backup whatever you have there
2. `ln -s /$HOME/<nextcloud-dir>/configs/dotssh/$HOSTNAME-ssh ~/.ssh`

To add SSH to NextCloud:
```
cd <nextcloud-dir>
cd configs
mkdir dotssh
mv ~/.ssh .
mv .ssh $HOSTNAME-ssh
ln -s $PWD/$HOSTNAME-ssh ~/.ssh
```
</details>

