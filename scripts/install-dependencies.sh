#!/usr/bin/env bash
# Install the command-line dependencies used by this repository.

set -euo pipefail

# macOS packages installed with Homebrew.
BREW_PACKAGES=(
    eza fish gh git jq lazygit mise openjdk@17 rustup starship zoxide zig \
        lua-language-server rust-analyzer zls
)

# macOS apps installed with Homebrew Cask.
BREW_CASKS=(
    ghostty zed zen
)

# Arch Linux packages available in the official repositories.
PACMAN_PACKAGES=(
    curl eza fish ghostty git github-cli jq lazygit mise jdk17-openjdk rustup starship \
        zed zoxide zig lua-language-server rust-analyzer zls
)

# Arch Linux packages from the AUR.
AUR_PACKAGES=(
    zen-browser-bin
)

# Rust packages installed with Cargo.
CARGO_PACKAGES=(
    bat tealdeer topgrade loc git-delta du-dust fd-find ripgrep bob-nvim
)

if [[ "$(uname -s)" == "Darwin" ]]; then # macOS
    if ! command -v brew >/dev/null 2>&1; then
        echo "Error: Homebrew is not installed on this system." >&2
        exit 1
    fi

    brew update
    brew install "${BREW_PACKAGES[@]}"
    brew install --cask "${BREW_CASKS[@]}"
elif [[ "$(uname -s)" == "Linux" ]]; then # Arch Linux
    sudo pacman -Syu --needed "${PACMAN_PACKAGES[@]}"

    if ! command -v paru >/dev/null 2>&1; then
        echo "Error: paru AUR helper is not installed." >&2
        exit 1
    fi

    paru -S --needed "${AUR_PACKAGES[@]}"
else
    echo "Error: Unsupported OS: $(uname -s)"
    exit 1
fi

curl -fsSL https://vite.plus | bash

rustup default stable

cargo install --locked "${CARGO_PACKAGES[@]}"

echo "Dependencies installed."
