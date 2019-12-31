-- let Prelude =
--       https://prelude.dhall-lang.org/v11.1.0/package.dhall sha256:99462c205117931c0919f155a6046aec140c70fb8876d208c7c77027ab19c2fa

-- dhall <<< '(./config/config.dhall).bazel_config("nanana")'
-- dhall-to-json <<< '(./config/config.dhall).bazel_config("nanana")'

let bazel_config =
  \(val : Text) -> 
      ''
      modules = ["packages/app_1/java,packages/module_a/java,packages/module_b/java"]
      workspace = ["packages", "${val}"]
      ''

in  { bazel_config = bazel_config
    }
