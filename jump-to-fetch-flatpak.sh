source $stdenv/setup

set -x 

export FLATPAK_DIR="$HOME/.local/share/flatpak"

rarray=($runtime)
bwrapargs="--dir /sys/block --dir /sys/bus --dir /sys/class --dir/dev --dir /sys/devices"
for i in "${rarray[@]}"
do
  d=$i/*
  base=$(basename $d)
  bwrapargs="$bwrapargs --ro-bind $d ${FLATPAK_DIR}/runtime/$base"
done

bwrap --dev-bind / / $bwrapargs bash $fetcher

