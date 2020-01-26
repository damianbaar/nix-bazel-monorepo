FROM lnl7/nix:latest

COPY nix /workspace/nix
COPY shell.nix /workspace/shell.nix

RUN nix-env -iA \
  pkgs.bazel \
  pkgs.bash \
  pkgs.jdk \
  pkgs.bazel-buildtools \
  -f /workspace/nix/nixpkgs.nix && nix-store --gc

WORKDIR /workspace

ENTRYPOINT [ "nix-shell" ]