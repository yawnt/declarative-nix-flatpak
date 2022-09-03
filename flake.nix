{
  description = "declarative flatpak";

  outputs = { self, nixpkgs }: rec {
    
    pkgs = import nixpkgs { system = "x86_64-linux"; };

    lib.flatpak = with import nixpkgs { system = "x86_64-linux"; }; callPackage ./flatpak.nix { };

    defaultPackage.x86_64-linux = 
        let
inputmap = pkgs.writeText "keyboard.json" ''
    {
      "name": "Keyboard",
      "idmatcher": "Keyboard",
      "mapping": 
      {
          "Volume Up": "up",
          "Volume Down": "down",
          "Forward": "right",
          "Back": "left",
          "Return": "enter",
          "Media Play": "play_pause",
          "Keyboard Menu": { "short": "back", "long": "debug" }
      }
    }
  '';

          runtime = lib.flatpak.fetchRuntimeFromFlatHub {
            name = "org.freedesktop.Platform";
            branch = "21.08";
            commit = "c7252386179c4c1ecf5d93bdaec6ca82852dddfdae7112b5c3177f7424c4a928";
            sha256 = "sha256-wuFiB2+x+Mj6FL9GgrknvD9Su6bWr5QVhgcB8/4uBQc=";
          };
          app = lib.flatpak.fetchAppFromFlatHub {
            name = "tv.plex.PlexHTPC";
            commit = "2e5a23587e69324c32c99c50e9c235d17cc7157b9f4f51bed4655401491f35bc";
            sha256 = "sha256-r9y4UTgCm3l62ltLKN9Asna7frMhZSMsShHw69R/0Os=";
            inherit runtime;
            patchPhase = ''
              ls $FLATPAK_DIR
              rm -rf $FLATPAK_DIR/app/tv.plex.PlexHTPC/current/active/files/resources/inputmaps/*
              ln -s ${inputmap} $FLATPAK_DIR/app/tv.plex.PlexHTPC/current/active/files/resources/inputmaps/keyboard.json
            '';
          };
        in
        lib.flatpak.wrapFlatpakLauncher app runtime;
  };
}
