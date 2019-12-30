ARTIFACT = """
<groupId>{0}.{1}</groupId>
<artifactId>{2}</artifactId>
<version>{3}</version>
"""

DEP_BLOCK = """
<dependency>
  <groupId>{0}</groupId>
  <artifactId>{1}</artifactId>
  <version>{2}</version>
</dependency>
""".strip()

PARENT = """
<parent>
  <groupId>{0}</groupId>
  <artifactId>{1}</artifactId>
  <version>{2}</version>
</parent>
"""

JavaDependencyInfo = provider(
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

_EMPTY_MAVEN_INFO = JavaDependencyInfo(
    maven_artifacts = depset(),
    maven_dependencies = depset(),
    other_dependencies = [],
)

_MAVEN_COORDINATES_PREFIX = "maven_coordinates="

def _maven_artifacts(targets):
    return [target[JavaDependencyInfo].maven_artifacts for target in targets if JavaDependencyInfo in target]

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

    return [JavaDependencyInfo(
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

def _pom_file(ctx):
    mvn_deps = depset(
        [],
        transitive = [target[JavaDependencyInfo].maven_dependencies for target in ctx.attr.targets],
    )

    deps = mvn_deps.to_list()

    version = ctx.var.get("pom_version", "LOCAL-SNAPSHOT")

    artifact_config = ctx.attr.artifact_config
    workspace = artifact_config.get("workspace")
    group_id = artifact_config.get("group_id")

    # WARNING too strong assumption
    artifact = ctx.label.package.split("/")
    parent_id = artifact[0]
    artifact_id = artifact[1] if len(artifact) > 1 else artifact[0]

    is_package_parent = len(artifact) == 0

    for labels in [target[JavaDependencyInfo].other_dependencies for target in ctx.attr.targets]:
        for label in labels:
            # WARNING check this condition
            # if label.workspace_name == workspace:
            deps.append("{}.{}:{}:{}".format(group_id, parent_id, label.name, version))

    formatted_deps = []

    for dep in _sort_artifacts(deps, ctx.attr.preferred_group_ids):
        parts = dep.split(":")
        if ":".join(parts[0:2]) in ctx.attr.excluded_artifacts:
            continue
        formatted_deps.append(DEP_BLOCK.format(*parts))

    version = ctx.var.get("pom_version", "LOCAL-SNAPSHOT")

    substitutions = {}
    substitutions.update(ctx.attr.substitutions)
    substitutions.update({
        "{generated_bzl_deps}": "\n".join(formatted_deps),
        "{pom_version}": version,
        "{artifact_desc}": ARTIFACT.format(group_id, parent_id, artifact_id, version),
        "{parent_pom}": PARENT.format(group_id, parent_id, version),
    })
    ctx.actions.expand_template(
        template = ctx.file.template_file,
        output = ctx.outputs.pom_file,
        substitutions = substitutions,
    )

pom_file = rule(
    implementation = _pom_file,
    attrs = {
        "artifact_config": attr.string_dict(default = {
            "workspace": "",
            "parent_id": "",
        }),
        "local_namespace": attr.string(),
        "template_file": attr.label(
            allow_single_file = True,
            default = "tools/pom_template.xml",
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
