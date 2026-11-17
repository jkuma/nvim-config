#!/bin/sh
# Symlink the repo to ~/.config/nvim; an existing config is kept as .bak.
set -eu

repo=$(cd "$(dirname "$0")" && pwd)
dst="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if [ "$(readlink "$dst" 2>/dev/null)" = "$repo" ]; then
    echo "already linked: $dst → $repo"
    exit 0
fi

mkdir -p "$(dirname "$dst")"
if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak"
    echo "backup: $dst.bak"
fi
ln -s "$repo" "$dst"
echo "link: $dst → $repo"
