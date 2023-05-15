{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
          nodejs18 = pkgs.stdenv.mkDerivation {
            name = "nodejs20.0.0";
            src = pkgs.fetchurl {
              url = "https://nodejs.org/dist/v20.0.0/node-v20.0.0-linux-x64.tar.gz";
              sha256 = "1kngfglyzfva95g4h1gjwq0ijx6ialg7nskvbib5ij3ghc59lhwm";
            };
            installPhase = ''
              echo "installing nodejs"
              mkdir -p $out
              cp -r ./ $out/
            '';
          };
        };

        devShells.default = pkgs.mkShell {

          buildInputs = [
            self'.packages.nodejs18
            pkgs.nodePackages.node-gyp-build
          ];

        };
      };
      flake = { };
    };
}
