{ pkgs, stdenvNoCC }:

let 
  wrapFlatpakLauncher = name: app: runtime: pkgs.writeScriptBin "${name}" ''
    FLATPAK_DIR=$HOME/.local/share/flatpak
    ${pkgs.bubblewrap}/bin/bwrap \
      --dev-bind / / \
      --tmpfs $FLATPAK_DIR \
      --ro-bind ${app} $FLATPAK_DIR/app \
      --ro-bind ${runtime} $FLATPAK_DIR/runtime \
      ${pkgs.flatpak}/bin/flatpak --user run ${name}
  '';
  fetchFromFlatHub = 
    { name, runtime ? null, ref, commit, sha256 }:
      stdenvNoCC.mkDerivation {
        nativeBuildInputs = [ pkgs.flatpak pkgs.cacert pkgs.bubblewrap ];

        runtime = if runtime != null then runtime else "";
        builder = ./jump-to-fetch-flatpak.sh;
        fetcher = ./fetch-flatpak.sh;
    
        outputHashAlgo = "sha256";
        outputHashMode = "recursive";
        outputHash = sha256;

        inherit name ref commit;
      };
  fetchRuntimeFromFlatHub = 
    { name, arch ? "x86_64", branch, commit, sha256 }:
    fetchFromFlatHub { ref = "${name}/${arch}/${branch}"; inherit name commit sha256; };
  fetchAppFromFlatHub =
    { name, arch ? "x86_64", branch ? "stable", runtime, commit, sha256 }:
    fetchFromFlatHub { ref = "${name}/${arch}/${branch}"; inherit name runtime commit sha256; };
in 
{
  inherit fetchRuntimeFromFlatHub fetchAppFromFlatHub wrapFlatpakLauncher;
} 
