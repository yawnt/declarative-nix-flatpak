{ pkgs, stdenvNoCC }:

let 
  wrapFlatpakLauncher = app: runtime: pkgs.writeScriptBin "${app.name}" ''
    FLATPAK_DIR=$HOME/.local/share/flatpak
    ${pkgs.bubblewrap}/bin/bwrap \
      --dev-bind / / \
      --tmpfs $FLATPAK_DIR \
      --ro-bind ${app} $FLATPAK_DIR/app \
      --ro-bind ${runtime} $FLATPAK_DIR/runtime \
      ${pkgs.flatpak}/bin/flatpak --user run ${app.name}
  '';
  fetchFromFlatHub = 
    { name
    , arch ? "x86_64"
    , branch ? "stable"
    , runtime ? null
    , commit
    , sha256
    , ...
    }@args :    
    stdenvNoCC.mkDerivation (args // {
      nativeBuildInputs = [ pkgs.flatpak pkgs.cacert pkgs.bubblewrap ];

      ref = "${name}/${arch}/${branch}";
      builder = ./jump-to-fetch-flatpak.sh;
      fetcher = ./fetch-flatpak.sh;
    
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = sha256;
    });
  fetchRuntimeFromFlatHub = args: fetchFromFlatHub args;
  fetchAppFromFlatHub = args: fetchFromFlatHub args;
in 
{
  inherit fetchRuntimeFromFlatHub fetchAppFromFlatHub wrapFlatpakLauncher;
} 
