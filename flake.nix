{
  description = "nix flake that wraps the released khulnasoft binaries";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      eachSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      packages = eachSystem (system:
        let
          khulnasoft = nixpkgs.legacyPackages.${system}.callPackage ./khulnasoft.nix { };
        in
        {
          khulnasoft = khulnasoft;
          default = khulnasoft;
        });

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
