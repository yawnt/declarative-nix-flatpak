{
  description = "declarative flatpak";

  outputs = { self, nixpkgs }: rec {
    
    lib.flatpak = with import nixpkgs { system = "x86_64-linux"; }; callPackage ./flatpak.nix { };

    defaultPackage.x86_64-linux = 
      let
        locale = lib.flatpak.fetchRuntimeFromFlatHub {
          name = "org.freedesktop.Platform.Locale";
          branch = "21.08";
          commit = "4610a6df4bbff9154a3d7217124cadcadd3384b0136e1fe4ce155d31b9e57923";
          sha256 = "sha256-dvxPHoQitIAKIPdkuSbcVRivaMsT9vsnqc69NY00zvg=";
        };
        h264 = lib.flatpak.fetchRuntimeFromFlatHub {
          name = "org.freedesktop.Platform.openh264";
          branch = "2.0";
          commit = "73f998362a6fc0d57e0c7e83e928d32b0ec14d10d0d94291033976bdcecc6b6b";
          sha256 = "sha256-HWXxff4J2eU5ItLTC0i6i0uh9cWZPJiRDR1flX/o6LA=";
        };
        gl = lib.flatpak.fetchRuntimeFromFlatHub {
          name = "org.freedesktop.Platform.GL.default";
          branch = "21.08";
          commit = "e10dc0a5370f7e421617e58cd96e0e171db640681442e9e78dfa576df801bfcd";
          sha256 = "sha256-rci84C/EvI3gifV+dMXN7fL8F6tD+88k9RHMBh1w4Rw=";
        };
        vaapi = lib.flatpak.fetchRuntimeFromFlatHub {
          name = "org.freedesktop.Platform.VAAPI.Intel";
          branch = "21.08";
          commit = "f2f00f9c91463312bbb70cee438e0241fae6116cb2a372e4b001714f8150a0a1";
          sha256 = "sha256-jzPHyyVm8fRFnERjs+RnlqJ+Smj55xD4Cea6oWDpDZU=";
        };
        platform = lib.flatpak.fetchRuntimeFromFlatHub {
          name = "org.freedesktop.Platform";
          runtime = [ gl locale h264 ];
          branch = "21.08";
          commit = "8b80c75fb9592ebd5fc5f0811f84a41efcdf0308eb425be41c9194bda0a2faf3";
          sha256 = "sha256-2pQYTQ4hDgewU8lCb8qZd011vsbiMrTpY/FfUdsaNhE=";
        };
        app = lib.flatpak.fetchAppFromFlatHub {
          name = "tv.plex.PlexHTPC";
          runtime = [ platform gl locale h264 vaapi ];
          commit = "d1d0233318d9b7cf6bf006a32869cb535c818d3e3a5d0920e87844ea6da3f5b7";
          sha256 = "sha256-jdsRMeHVoS5e4lwuMTPkezG/nf/MluRGBlbpLRel7GM=";
        };
      in
        app;

  };
}
