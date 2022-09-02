source $stdenv/setup

set -x 

export FLATPAK_DIR="$HOME/.local/share/flatpak"

if [ -n "$runtime" ]; then
  bwrap --dev-bind / / --ro-bind $runtime "${FLATPAK_DIR}/runtime" bash $fetcher
else
  bash $fetcher
fi
