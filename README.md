#### Bazel & Nix Monorepo example

### Features & Integration
* `ide` integration - `bazel` does not work pretty well with `ide`'s - there is custom `pom` generation based on `bazel-tools/pom.bzl` which generate local deps as well, so from `ide` perspective all are treated as `maven` dependencies

### Assumptions
* each module can carry some binary
* each module can produce docker
* modules can be referenced locally and autocompletion works from `ide` perspective
* fast incremental reproducible & remote builds

### TODO
* generate pom for root as 
* generate packages pom xml
* generate pom with local deps - done
* create sh scripts to run binary from nixpkgs rules - done
* create custom nix script as a dependency of binary file for module
* create pinned nixpkgs

#### Stack
* `nixpkgs`
* `bazel`
* [`niv`](https://github.com/nmattia/niv)
* `lorri`
* `dir-env`
* `java`

#### Related articles
* https://github.com/tweag/rules_nixpkgs