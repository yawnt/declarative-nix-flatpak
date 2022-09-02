set -x

mkdir $out

mkdir -p ${FLATPAK_DIR}

flatpak --user remote-add --no-gpg-verify flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user -y install $ref

flatpak --user -y update --commit=$commit $ref

if [ -d "${FLATPAK_DIR}/app" ]; then
  mv ${FLATPAK_DIR}/app/$name $out/
else
  mv ${FLATPAK_DIR}/runtime/* $out/
fi

