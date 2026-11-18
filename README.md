# .dotfiles

Personal dotfiles for WSL2 Arch Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
.
├── install.sh       # Full machine bootstrap
├── Makefile         # make test | make install | make link
├── Dockerfile       # Arch Linux + bats test environment
├── packages/        # Stow packages (each mirrors $HOME layout)
│   ├── ccstatusline/
│   ├── git/
│   ├── htop/
│   ├── mise/
│   ├── rtk/
│   └── zsh/
└── tests/           # bats-core test suite
```

## Fresh setup

```sh
git clone https://github.com/macoaure/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

`install.sh` will:

1. Install `zsh`, `git`, `stow` via pacman
2. Install `yay` (AUR helper) if missing
3. Install `mise`, `gh` via yay
4. Install `pnpm` and `rustup`
5. Install oh-my-zsh + `zsh-syntax-highlighting` + `zsh-autosuggestions`
6. Stow all packages into `$HOME`

## Link only (tools already installed)

```sh
make link
```

## Tests

Requires Docker.

```sh
make test
```

Runs the full bats suite inside a clean Arch Linux container:
- `install.bats` — bootstrap completes without errors
- `stow.bats` — symlinks created, none broken
- `shell.bats` — `zsh` sources `.zshrc` cleanly
- `tools.bats` — all expected tools are on `$PATH`

