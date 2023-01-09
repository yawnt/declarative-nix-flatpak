{ pkgs, stdenvNoCC }:

let
  simple = pkgs.writeTextDir "etc/foobar" ''foobarIsMyFile'';
  wrapFlatpakLauncher = name: app: runtime: 
    let
      runtime-dir = pkgs.symlinkJoin { name = "runtime-for-${name}"; paths = runtime; };
    in
      pkgs.writeScriptBin "${name}" ''
        FOO="${(toString runtime)}"
rarray=($FOO)
bwrapargs=""
for i in "''${rarray[@]}"
do
  d=($i/*)
  base=$(basename $d)
  bwrapargs="$bwrapargs --ro-bind $d $HOME/.local/share/flatpak/runtime/$base"
done
echo $bwrapargs
        FLATPAK_DIR=$HOME/.local/share/flatpak
        ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --tmpfs $FLATPAK_DIR \
          --ro-bind ${app} $FLATPAK_DIR/app \
          $bwrapargs \
          ${pkgs.flatpak}/bin/flatpak --user run ${name}
      '';
  fetchFromFlatHub = 
    isRuntime: { name, arch ? "x86_64", branch ? "stable", runtime ? null, commit, sha256 }:
      let 
        ref = "${name}/${arch}/${branch}";
      in
        stdenvNoCC.mkDerivation {
          nativeBuildInputs = [ pkgs.flatpak pkgs.cacert pkgs.bubblewrap simple ];

          isRuntime = if isRuntime then isRuntime else "";
          runtime = if runtime != null then runtime else "";

          builder = ./jump-to-fetch-flatpak.sh;
          fetcher = ./fetch-flatpak.sh;
    
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
          outputHash = sha256;

          inherit name ref commit;
        };
  fetchRuntimeFromFlatHub = fetchFromFlatHub true;
  fetchAppFromFlatHub = 
    args@ { name, runtime, ... }:
      let
        app = fetchFromFlatHub false args;
      in
        wrapFlatpakLauncher name app runtime;
in 
{
  inherit fetchAppFromFlatHub fetchRuntimeFromFlatHub;
} 
