{nixpkgs}:
with nixpkgs;
{
  inherit bazel;
  inherit bash;
  inherit jdk;
  inherit bazel-buildtools;
  inherit bazel-watcher;
  inherit figlet;
}