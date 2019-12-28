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
