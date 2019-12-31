{ callPackage }: 
{
  bazel = callPackage ./bazel.nix {};
  maven = callPackage ./maven.nix {};
}