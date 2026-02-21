# Migration Plan: chezmoi

## Source State Structure

```
dotfiles/                              # chezmoi source repo
  .chezmoi.toml.tmpl                   # Config template (prompts for email, git key)
  .chezmoidata/
    packages.yaml                      # Declarative package lists per OS/PM
  .chezmoiignore                       # OS-conditional ignores
  .chezmoiscripts/
    run_onchange_install-packages-darwin.sh.tmpl
    run_onchange_install-packages-linux.sh.tmpl
    run_once_install-binaries.sh.tmpl
  dot_gitconfig.tmpl                   # Templated .gitconfig
  dot_tmux.conf                        # .tmux.conf (verbatim)
  dot_alias                            # Shell aliases
  private_dot_config/
    starship.toml                      # Starship prompt config
```

## Phases

### Phase 1: Install and Init

- [x] Install chezmoi: `brew install chezmoi` (macOS) or via install script (Linux)
- [x] Run `chezmoi init` to create `~/.local/share/chezmoi`
- [x] Connect to the existing `asksven/dotfiles` repo on GitHub

### Phase 2: Migrate Existing Dotfiles

- [x] **Git config** — add `git/.gitconfig` as `dot_gitconfig.tmpl`, templatize email + signing key
- [x] **Shell aliases** — add `system/.alias` as `dot_alias`
- [x] **Tmux** — add `config/tmux/.tmux.conf` as `dot_tmux.conf` (verbatim)
- [x] **Starship** — add `starship/.config/starship.toml` as `private_dot_config/starship.toml`
- [x] **kubectl completion** — drop the vendored file, use `source <(kubectl completion bash)` in `.bashrc` template

### Phase 3: Config Template

- [x] Create `.chezmoi.toml.tmpl` with `promptStringOnce` for machine-specific data (email, git signing key)

### Phase 4: Declarative Package Install

- [x] Create `.chezmoidata/packages.yaml` with per-OS package lists:
  - `darwin.brews` (brew packages for macOS)
  - `linux.apt` (apt packages for Debian/Ubuntu)
  - `linux.dnf` (dnf packages for Fedora/RHEL)
- [x] Create `run_onchange_install-packages-darwin.sh.tmpl` — uses `brew bundle`, re-runs when package list changes
- [x] Create `run_onchange_install-packages-linux.sh.tmpl` — detects apt vs dnf via `lookPath`, runs `sudo -v` upfront

### Phase 5: GitHub Release Binaries

- [x] Create `run_once_install-binaries.sh.tmpl` — downloads binaries (kubectl, helm, etc.) using chezmoi's native `.chezmoi.os` and `.chezmoi.arch`. Checks `command -v` before downloading (idempotent). Versions pinned in `packages.yaml`.

### Phase 6: PATH and Shell Integration

- [x] Add `export PATH="$HOME/.local/bin:$PATH"` to `dot_bashrc.tmpl`
- [x] Use `{{ if lookPath "kubectl" }}source <(kubectl completion bash){{ end }}` for dynamic completion

### Phase 7: .chezmoiignore

- [x] Create `.chezmoiignore` to exclude `README.md`, `LICENSE`, and OS-specific paths

### Phase 8: Cleanup Old Repo

- [x] Remove: `install.sh`, `config/`, `bin/kubectl`, `bin/helm`, `dotdirs/`, `system/`, empty `.gitmodules`

### Phase 9: Push and Test

- [x] Commit and push
- [ ] Test: `chezmoi init --apply git@github.com:asksven/dotfiles.git` on fresh machine
- [x] Test in Docker: Ubuntu (apt) and Fedora (dnf) containers

## Key Decisions

- chezmoi replaces stow entirely — no symlinks, chezmoi copies files
- Source repo = `asksven/dotfiles` on GitHub
- `run_onchange_` for PM packages (re-runs on list change)
- `run_once_` for GitHub release binaries (runs once per host)
- `~/.local/bin` for user-local binaries, PATH set in `.bashrc`
- `sudo -v` upfront on Linux install scripts
- Separate apt/dnf lists in `packages.yaml`
- Drop vendored binaries — install via scripts

## Verification

```bash
chezmoi doctor                  # Verify setup is healthy
chezmoi apply -n -v             # Dry-run, see all changes
chezmoi data                    # Verify template variables
chezmoi execute-template \
  '{{ .chezmoi.os }}/{{ .chezmoi.arch }}'  # Test platform detection
```
