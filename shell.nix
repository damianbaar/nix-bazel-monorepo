{
  nixpkgs ? import <nixos-unstable> {}
}:
with nixpkgs.pkgs;
mkShell {
  # TODO bazel-watch
  # TODO generate-poms -> bazel command
  buildInputs = [bazel bash maven jdk bazel-buildtools];
  shellHook = ''
    echo elo!
    bazel build //...
    echo "prepare poms"
    echo "packages - autogenerte based on files"
  '';
}

