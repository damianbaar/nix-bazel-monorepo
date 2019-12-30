package(default_visibility = ["//visibility:public"])

sh_binary(
    name = "nix-hello",
    srcs = ["local-run.sh"],
    data = [
        "nix-jq",
        "@nix-hello//:bin",
        "@nix-test-script//:bin",
    ],
)

sh_binary(
    name = "nix-jq",
    srcs = ["local-run.sh"],
    data = ["@nix-jq//:bin"],
)
