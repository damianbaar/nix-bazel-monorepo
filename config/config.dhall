-- let Prelude =
--       https://prelude.dhall-lang.org/v11.1.0/package.dhall sha256:99462c205117931c0919f155a6046aec140c70fb8876d208c7c77027ab19c2fa

let bazel_config =
        λ(val : Text)
      → ''
          modules = ["${val}"]
          workspace = ["packages", "${val}"]
        ''

in  { bazel_config = bazel_config }
