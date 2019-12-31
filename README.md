Bazel & Nix & Dhall Monorepo example
------
* `nix` for reproducibility and isolated environment 
* `bazel` for fast incremental rebuilds and module `query` system 
* `dhall` for converting and spread configuration to targets, like `nix`, `bazel`.

### Features & Integration
* `ide` integration - `bazel` does not work pretty well with `ide`'s - there is custom `pom` generation based on `bazel-tools/pom.bzl` which generate local deps as well, so from `ide` perspective all are treated as `maven` dependencies

### Assumptions
* each module can carry some binary
* each module can produce docker
* modules can be referenced locally and autocompletion works from `ide` perspective
* fast incremental reproducible & remote builds

#### Stack
* [`nixpkgs`](https://nixos.org/nixpkgs/download.html)
* [`bazel`](https://bazel.build/)
* [`niv`](https://github.com/nmattia/niv)
* [`lorri`](https://github.com/target/lorri)
* [`dir-env`](https://direnv.net/)
* [`dhall`](https://github.com/dhall-lang/dhall-lang)

#### Related articles
* https://github.com/tweag/rules_nixpkgs

#### Caveats
* https://github.com/dhall-lang/dhall-haskell/releases

### TODO
* create custom nix script as a dependency of binary file for module (done) with buildInputs (? - has to be defined manually)
* shell - run bazel -> generate poms (bazel build + symlink)
