-- let Prelude =
--       https://prelude.dhall-lang.org/v11.1.0/package.dhall sha256:99462c205117931c0919f155a6046aec140c70fb8876d208c7c77027ab19c2fa

-- TODO alias on SHELL_INPUT -> array with spaces as separator
let namespace = "com.example"

let presentWorkingDirectory = env:PWD as Text

let nixPath = env:NIX_PATH as Text

let javaModules = env:JAVA_MODULES_2 as Text

let bazel_config =
        λ(args : { modules : List Text, workspaces : List Text })
      → ''
        namespace = "${namespace}"
        namespace_workspace = "com_example"
        test = "${javaModules}"

        workspace = ["${presentWorkingDirectory}"]
        modules = ["${nixPath}"]
        ''

in  { bazel_config = bazel_config }
