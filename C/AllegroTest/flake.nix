{
  description = "Allegro NixShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }: {
    devShells.x86_64-linux =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in {
        default = pkgs.mkShell {
          name = "allegro5";
          buildInputs = with pkgs;[
            allegro5
            gcc
            cmake
            dbus
          ];
          nativeBuildInputs = with pkgs; [
            pkg-config
          ];
          dbus = pkgs.dbus;
        };
      };
  };
}
