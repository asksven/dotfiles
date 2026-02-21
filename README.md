# My dotfiles

Managed with [chezmoi](https://chezmoi.io/).

## Bootstrap a new machine

```bash
# One-liner: install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply asksven
```

If chezmoi is already installed:

```bash
chezmoi init --apply git@github.com:asksven/dotfiles.git
```

## Daily usage

```bash
chezmoi update -v    # Pull and apply latest changes
chezmoi add <file>   # Add a new dotfile
chezmoi edit <file>  # Edit a managed dotfile
chezmoi diff         # See pending changes
chezmoi apply -v     # Apply changes
```

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

