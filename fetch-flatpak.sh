source $stdenv/setup

set -x 

export FLATPAK_DIR="$HOME/.local/share/flatpak"

# Sad, just because otherwise we cannot install h264 :(
mkdir -p /sys/{block,bus,class,dev,devices}

mkdir -p ${FLATPAK_DIR}
mkdir -p $out

flatpak --user remote-add --no-gpg-verify flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --verbose --user -y install $ref

flatpak --user -y update --commit=$commit $ref

if [ -z "$isRuntime" ]; then
  mv "${FLATPAK_DIR}/app/${name}" $out/
else
  mv "${FLATPAK_DIR}/runtime/${name}" $out/
fi

