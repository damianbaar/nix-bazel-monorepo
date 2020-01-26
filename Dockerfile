FROM lnl7/nix:latest

COPY nix /environment/nix
COPY shell.nix /environment/shell.nix

# TODO take from nix variable
RUN nix-env -iA \
  pkgs.bazel \
  pkgs.bash \
  pkgs.jdk \
  pkgs.bazel-buildtools \
  -f /environment/nix/nixpkgs.nix && nix-store --gc

WORKDIR /workspace

ENTRYPOINT [ "nix-shell" ]