source $stdenv/setup

set -x 

export FLATPAK_DIR="$HOME/.local/share/flatpak"

rarray=($runtime)
bwrapargs=""
for i in "${rarray[@]}"
do
  d=$i/*
  base=$(basename $d)
  bwrapargs="$bwrapargs --ro-bind $d ${FLATPAK_DIR}/runtime/$base"
done

if [ -n "$runtime" ]; then
  bwrap --dev-bind / / $bwrapargs bash $fetcher
else
  bash $fetcher
fi

