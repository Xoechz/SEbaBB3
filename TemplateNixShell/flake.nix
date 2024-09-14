{
  description = "Template NixShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }: {
    devShells.x86_64-linux =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in {
        default = pkgs.mkShell {
          name = "template";
          # buildInputs = with pkgs;[
          #   # Add your dependencies here
          # ];
        };
      };
  };
}
