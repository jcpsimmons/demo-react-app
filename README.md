1. [Create flake from template](https://github.com/hercules-ci/flake-parts)
2. `nix flake init -t github:hercules-ci/flake-parts`
3. create a devshell
4. in the devshell create a react app and run it
5. create the buildNpmPackage closure
6. Hash error
7. explain npm deps hash, add prefetch-npm-deps to dev shell
8. generate hash
9. build app and verify it exists
10. serve it with serve-test-app/httplz package
