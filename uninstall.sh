#!/usr/bin/env bash
set -euo pipefail
PREFIX="${PREFIX:-$HOME/.local}"
rm -f "$PREFIX/bin/musicnode" "$PREFIX/share/applications/musicnode.desktop"
echo "MusicNode removed from $PREFIX."
echo "Your config at ~/.config/musicnode/ was left untouched."
