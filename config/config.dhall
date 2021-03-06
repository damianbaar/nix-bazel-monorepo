-- let Prelude =
--       https://prelude.dhall-lang.org/v11.1.0/package.dhall sha256:99462c205117931c0919f155a6046aec140c70fb8876d208c7c77027ab19c2fa

-- TODO alias on SHELL_INPUT -> array with spaces as separator
let bazel_config =
        λ(modules : Text)
      → λ(workspaces : Text)
      → ''
        namespace = "com.example"
        namespace_workspace = "com_example"

        modules = ["${modules}"]
        workspace = ["${workspaces}"]
        ''

in  { bazel_config = bazel_config }
