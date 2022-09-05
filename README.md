declarative-nix-flatpak
=======================

install flatpak, the nix way!

```nix
{
  description = "Plex HTPC";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flatpak.url = "github:yawnt/declarative-nix-flatpak/main";

  outputs = { self, nixpkgs, flatpak }: {

    defaultPackage.x86_64-linux = 
      let
        runtime = flatpak.lib.flatpak.fetchRuntimeFromFlatHub {
          name = "org.freedesktop.Platform";
          branch = "21.08";
          commit = "c7252386179c4c1ecf5d93bdaec6ca82852dddfdae7112b5c3177f7424c4a928";
          sha256 = "sha256-wuFiB2+x+Mj6FL9GgrknvD9Su6bWr5QVhgcB8/4uBQc=";
        };
        app = flatpak.lib.flatpak.fetchAppFromFlatHub {
          name = "tv.plex.PlexHTPC";
          commit = "2e5a23587e69324c32c99c50e9c235d17cc7157b9f4f51bed4655401491f35bc";
          sha256 = "sha256-yxnsiou/RldhfdP4D7J7i00uNGm0TjHgrIp0TTwUq3o=";
          inherit runtime;
        };
      in
        flatpak.lib.flatpak.wrapFlatpakLauncher "tv.plex.plexHTPC" app runtime;
  };
}
```
