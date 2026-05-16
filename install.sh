#!/usr/bin/env bash
# Install MusicNode into ~/.local (or $PREFIX if set).
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$PREFIX/bin" "$PREFIX/share/applications"

install -m 755 "$SCRIPT_DIR/musicnode" "$PREFIX/bin/musicnode"
echo "→ $PREFIX/bin/musicnode"

install -m 644 "$SCRIPT_DIR/musicnode.desktop" "$PREFIX/share/applications/musicnode.desktop"
echo "→ $PREFIX/share/applications/musicnode.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$PREFIX/share/applications" 2>/dev/null || true
fi

echo
echo "Installed. Launch it from your apps menu, or run:"
echo "  musicnode"
echo
case ":$PATH:" in
    *":$PREFIX/bin:"*) ;;
    *) echo "Warning: $PREFIX/bin is not in your PATH. Add this to your shell rc:"
       echo '  export PATH="$HOME/.local/bin:$PATH"' ;;
esac
