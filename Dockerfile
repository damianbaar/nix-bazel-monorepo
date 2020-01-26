FROM lnl7/nix:latest

COPY nix /environment/nix
COPY shell.nix /environment/shell.nix

RUN nix-env -f environment/nix/deps.nix -i '.*' && nix-store --gc

WORKDIR /workspace

ENTRYPOINT [ "nix-shell" ]