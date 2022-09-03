source $stdenv/setup

export FLATPAK_DIR="$HOME/.local/share/flatpak"
mkdir -p $FLATPAK_DIR

if [ -n "$runtime" ]; then
  bwrap --dev-bind / / --ro-bind $runtime "${FLATPAK_DIR}/runtime" bash $fetcher
else
  bash $fetcher
fi
