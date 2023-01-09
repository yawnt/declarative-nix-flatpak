source $stdenv/setup

set -x 

# this is very sad, but for some weird reason bwrap (which flatpak runs)
# requires these /sys files to be present. i refuse to relax the sandbox,
# so here we go :(
export WRITABLEROOT=$(mktemp -d)
mkdir -p $WRITABLEROOT/sys/{block,bus,class,dev,devices}

export XDG_DATA_HOME=$(mktemp -d)

rarray=($runtime)
bwrapargs=""
for i in "${rarray[@]}"
do
  d=($i/*)
  base=$(basename $d)
  bwrapargs="$bwrapargs --ro-bind $d ${XDG_DATA_HOME}/flatpak/runtime/$base"
done

bwrap \
  --bind $WRITABLEROOT / \
  --bind /bin /bin --bind /build /build --dev-bind /dev /dev \
  --bind /etc /etc --bind /nix /nix --bind /proc /proc --bind /tmp /tmp \
  $bwrapargs \
  bash $fetcher


