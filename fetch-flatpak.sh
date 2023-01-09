source $stdenv/setup

set -x 

flatpak --user remote-add --no-gpg-verify flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --verbose --user -y install $ref

flatpak --user -y update --commit=$commit $ref

mkdir -p $out

if [ -z "$isRuntime" ]; then
  mv "$XDG_DATA_HOME/flatpak/app/${name}" $out/
else
  mv "$XDG_DATA_HOME/flatpak/runtime/${name}" $out/
fi

