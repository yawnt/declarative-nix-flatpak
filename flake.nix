{
  description = "declarative flatpak";

  outputs = { self, nixpkgs }: rec {
    
    lib.flatpak = with import nixpkgs { system = "x86_64-linux"; }; callPackage ./flatpak.nix { };

  };
}
