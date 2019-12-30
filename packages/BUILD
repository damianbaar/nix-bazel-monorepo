load("@com_example//:tools/generate-pom.bzl", "pom_file")

pom_file(
    name = "pom",
    artifact_config = {
        "group_id": "com.example",
    },
    targets = [
        # ":module_b",
    ],
    template_file = "@com_example//template:packages_pom.xml",
)
