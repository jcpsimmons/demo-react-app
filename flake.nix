{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {

          test-app = pkgs.buildNpmPackage {
            name = "test-app";
            src = ./.;


            buildInputs = with pkgs; [
              nodejs-18_x
            ];

            npmPackFlags = [ "--ignore-scripts" ];

            npmBuild = ''
              npm run build
            '';

            # enter dev shell and run prefetch-npm-deps on package lock file
            npmDepsHash = "sha256-jqESS/Gr3PnN/Vica+bSlv8VEeQdtP9QUfq9xpCIWs8=";

            installPhase = ''
              mkdir $out
              cp -r build/ $out
            '';
          };

          serve-test-app = pkgs.writeShellScriptBin "serve-test-app" ''
            #!/usr/bin/env bash
            cd ${self'.packages.test-app}/build
            ${pkgs.httplz}/bin/httplz
          '';
        };

        devShells.default = pkgs.mkShell {

          buildInputs = [
            pkgs.nodejs-18_x
            # self'.packages.test-app
            pkgs.httplz
            pkgs.nodePackages.node-gyp-build
            pkgs.prefetch-npm-deps
          ];

        };
      };
      flake = { };
    };
}
