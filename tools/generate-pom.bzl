group = "com.example"
packages_group = group + ".packages"

DEP_BLOCK = """
<dependency>
  <groupId>{0}</groupId>
  <artifactId>{1}</artifactId>
  <version>{2}</version>
</dependency>
""".strip()

INTERNAL = """
<dependency>
  <groupId>{0}</groupId>
  <artifactId>{1}</artifactId>
  <version>sth.sth</version>
</dependency>
""".strip()

MavenInfo = provider(
    fields = {
        "maven_artifacts": """
        The Maven coordinates for the artifacts that are exported by this target: i.e. the target
        itself and its transitively exported targets.
        """,
        "maven_dependencies": """
        The Maven coordinates of the direct dependencies, and the transitively exported targets, of
        this target.
        """,
        "other_dependencies": """
        """,
    },
)

_EMPTY_MAVEN_INFO = MavenInfo(
    maven_artifacts = depset(),
    maven_dependencies = depset(),
)

_MAVEN_COORDINATES_PREFIX = "maven_coordinates="

def _maven_artifacts(targets):
    return [target[MavenInfo].maven_artifacts for target in targets if MavenInfo in target]

def _collect_maven_info_impl(_target, ctx):
    tags = getattr(ctx.rule.attr, "tags", [])
    deps = getattr(ctx.rule.attr, "deps", [])
    exports = getattr(ctx.rule.attr, "exports", [])
    maven_artifacts = []
    for tag in tags:
        if tag in ("maven:compile_only", "maven:shaded"):
            return [_EMPTY_MAVEN_INFO]
        if tag.startswith(_MAVEN_COORDINATES_PREFIX):
            maven_artifacts.append(tag[len(_MAVEN_COORDINATES_PREFIX):])

    targets = [_get_label(target) for target in deps]
    other_dependencies = []

    for label in targets:
        if label.workspace_name != "maven":
            other_dependencies.append(label)

    return [MavenInfo(
        maven_artifacts = depset(maven_artifacts, transitive = _maven_artifacts(exports)),
        maven_dependencies = depset([], transitive = _maven_artifacts(deps + exports)),
        other_dependencies = other_dependencies,
    )]

_collect_maven_info = aspect(
    attr_aspects = [
        "deps",
        "exports",
        "workspace",
    ],
    doc = """
  Collects the Maven information for targets, their dependencies, and their transitive exports.
  """,
    implementation = _collect_maven_info_impl,
)

def _prefix_index_of(item, prefixes):
    """Returns the index of the first value in `prefixes` that is a prefix of `item`.
    If none of the prefixes match, return the size of `prefixes`.
    Args:
      item: the item to match
      prefixes: prefixes to match against
    Returns:
      an integer representing the index of the match described above.
    """
    for index, prefix in enumerate(prefixes):
        if item.startswith(prefix):
            return index
    return len(prefixes)

def _sort_artifacts(artifacts, prefixes):
    """Sorts `artifacts`, preferring group ids that appear earlier in `prefixes`.
    Values in `prefixes` do not need to be complete group ids. For example, passing `prefixes =
    ['io.bazel']` will match `io.bazel.rules:rules-artifact:1.0`. If multiple prefixes match an
    artifact, the first one in `prefixes` will be used.
    _Implementation note_: Skylark does not support passing a comparator function to the `sorted()`
    builtin, so this constructs a list of tuples with elements:
      - `[0]` = an integer corresponding to the index in `prefixes` that matches the artifact (see
        `_prefix_index_of`)
      - `[1]` = parts of the complete artifact, split on `:`. This is used as a tiebreaker when
        multilple artifacts have the same index referenced in `[0]`. The individual parts are used so
        that individual artifacts in the same group are sorted correctly - if just the string is used,
        the colon that separates the artifact name from the version will sort lower than a longer
        name. For example:
        -  `com.example.project:base:1
        -  `com.example.project:extension:1
        "base" sorts lower than "exension".
      - `[2]` = the complete artifact. this is a convenience so that after sorting, the artifact can
      be returned.
    The `sorted` builtin will first compare the index element and if it needs a tiebreaker, will
    recursively compare the contents of the second element.
    Args:
      artifacts: artifacts to be sorted
      prefixes: the preferred group ids used to sort `artifacts`
    Returns:
      A new, sorted list containing the contents of `artifacts`.
    """
    indexed = []
    for artifact in artifacts:
        parts = artifact.split(":")
        indexed.append((_prefix_index_of(parts[0], prefixes), parts, artifact))

    return [x[-1] for x in sorted(indexed)]

def _get_label(dep):
    return dep.label

# in:  //packages/module_a/java:module_a
# out: <dependency>
#         <groupId>com.example.packages</groupId>
#         <artifactId>module_b</artifactId>
#         <version>LOCAL-SNAPSHOT</version>
#     </dependency>

def _pom_file(ctx):
    mvn_deps = depset(
        [],
        transitive = [target[MavenInfo].maven_dependencies for target in ctx.attr.targets],
    )

    deps = mvn_deps.to_list()

    for labels in [target[MavenInfo].other_dependencies for target in ctx.attr.targets]:
        for label in labels:
            deps.append("com:{}:{}".format(label.package, label.name))

    print(deps)

    formatted_deps = []

    for dep in _sort_artifacts(deps, ctx.attr.preferred_group_ids):
        parts = dep.split(":")
        if ":".join(parts[0:2]) in ctx.attr.excluded_artifacts:
            continue
        if len(parts) == 2:
            template = INTERNAL
        if len(parts) == 3:
            template = DEP_BLOCK
        elif len(parts) == 5:
            template = DEP_BLOCK
            # template = CLASSIFIER_DEP_BLOCK

        else:
            fail("Unknown dependency format: %s" % dep)
        formatted_deps.append(template.format(*parts))

    substitutions = {}
    substitutions.update(ctx.attr.substitutions)
    substitutions.update({
        "{generated_bzl_deps}": "\n".join(formatted_deps),
        "{pom_version}": ctx.var.get("pom_version", "LOCAL-SNAPSHOT"),
    })
    ctx.actions.expand_template(
        template = ctx.file.template_file,
        output = ctx.outputs.pom_file,
        substitutions = substitutions,
    )

pom_file = rule(
    implementation = _pom_file,
    attrs = {
        "workspace": attr.string(default = "*"),
        "local_namespace": attr.string(),
        "template_file": attr.label(
            allow_single_file = True,
            default = "pom_template.xml",
        ),
        "substitutions": attr.string_dict(
            allow_empty = True,
            mandatory = False,
        ),
        "targets": attr.label_list(
            mandatory = True,
            aspects = [_collect_maven_info],
        ),
        "preferred_group_ids": attr.string_list(),
        "excluded_artifacts": attr.string_list(),
    },
    outputs = {"pom_file": "%{name}.xml"},
)

# def pom(targets, name, template_file):
#     pom_file(
#         name = name,
#         workspace = "root",
#         targets = targets,
#     )