workspace(name = "com_example")

load("//config:__generated__/config.bzl", "namespace", "namespace_workspace")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

RULES_JVM_EXTERNAL_TAG = "3.0"

RULES_JVM_EXTERNAL_SHA = "62133c125bf4109dfd9d2af64830208356ce4ef8b165a6ef15bbff7460b35c3a"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "junit:junit:4.12",
        "org.hamcrest:hamcrest-library:1.3",
        "com.google.inject:guice:4.0",
        "com.google.guava:guava:27.1-jre",
        "org.apache.kafka:kafka_2.11:2.1.1",
        "io.confluent:kafka-avro-serializer:5.0.1",
        "log4j:log4j:1.2.17",
        "org.slf4j:slf4j-log4j12:1.7.25",
        "org.springframework.boot:spring-boot:2.2.2.RELEASE",
        "org.springframework.boot:spring-boot-autoconfigure:2.2.2.RELEASE",
        "org.springframework.boot:spring-boot-starter-web:2.2.2.RELEASE",
    ],
    maven_install_json = "//:maven_install.json",
    repositories = [
        # Private repositories are supported through HTTP Basic auth
        # "http://username:password@localhost:8081/artifactory/my-repository",
        "https://packages.confluent.io/maven/",
        "https://jcenter.bintray.com/",
        "https://maven.google.com",
        "https://repo1.maven.org/maven2",
    ],
)

load("@maven//:defs.bzl", "pinned_maven_install")

pinned_maven_install()

http_archive(
    name = "bazel_common",
    sha256 = "d8c9586b24ce4a5513d972668f94b62eb7d705b92405d4bc102131f294751f1d",
    strip_prefix = "bazel-common-413b433b91f26dbe39cdbc20f742ad6555dd1e27",
    url = "https://github.com/google/bazel-common/archive/413b433b91f26dbe39cdbc20f742ad6555dd1e27.zip",
)

http_archive(
    name = "bazel_skylib",
    sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
    url = "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

######
# SH
#####
http_archive(
    name = "rules_sh",
    sha256 = "2613156e96b41fe0f91ac86a65edaea7da910b7130f2392ca02e8270f674a734",
    strip_prefix = "rules_sh-0.1.0",
    urls = ["https://github.com/tweag/rules_sh/archive/v0.1.0.tar.gz"],
)

load("@rules_sh//sh:repositories.bzl", "rules_sh_dependencies")

rules_sh_dependencies()

######
# NIX
#####
http_archive(
    name = "io_tweag_rules_nixpkgs",
    sha256 = "f5af641e16fcff5b24f1a9ba5d93cab5ad26500271df59ede344f1a56fc3b17d",
    strip_prefix = "rules_nixpkgs-0.6.0",
    urls = ["https://github.com/tweag/rules_nixpkgs/archive/v0.6.0.tar.gz"],
)

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_git_repository", "nixpkgs_local_repository", "nixpkgs_package")

nixpkgs_local_repository(
    name = "nixpkgs",
    nix_file = "//:nix/nixpkgs.nix",
    nix_file_deps = [
        "//:nix/sources.nix",
        "//:nix/sources.json",
    ],
)

# INFO this is a repository
nixpkgs_package(
    name = "nix-hello",
    nix_file_content = """
      (import ./nix/default.nix {}).pkgs.hello
    """,
    nix_file_deps = [
        "//:nix/default.nix",
        "//:nix/sources.nix",
        "//:nix/sources.json",
    ],
    repository = "@nixpkgs",
)

nixpkgs_package(
    name = "nix-jq",
    attribute_path = "jq",
    repository = "@nixpkgs",
)

nixpkgs_package(
    name = "nix-test-script",
    nix_file_content = """
      (import ./nix/default.nix {}).testScript
    """,
    nix_file_deps = [
        "//:nix/default.nix",
        "//:nix/sources.nix",
        "//:nix/sources.json",
    ],
    repository = "@nixpkgs",
)
