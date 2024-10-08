{
  description = "PureScript core packages CI setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    purescript-overlay.url = "github:thomashoneyman/purescript-overlay";
    purescript-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = builtins.attrValues self.overlays;
      });
    in
    {
      overlays = {
        purescript = inputs.purescript-overlay.overlays.default;
      };

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
            chez = pkgs.chez.overrideAttrs (final: prev: {
              postFixup = if pkgs.stdenv.isDarwin then ''
                install_name_tool -add_rpath ${pkgs.pcre2.out}/lib $out/bin/scheme
                install_name_tool -add_rpath ${pkgs.icu}/lib $out/bin/scheme
              ''
              else ''
                patchelf $out/bin/scheme --add-rpath ${pkgs.pcre2.out}/lib
                patchelf $out/bin/scheme --add-rpath ${pkgs.icu}/lib
              '';
            });
        in {
          default = pkgs.mkShell {
            name = "purescm";
            packages = [chez];
          };
        });

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
    };
}
