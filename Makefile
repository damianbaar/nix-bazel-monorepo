refresh_deps:
	bazel run @unpinned_maven//:pin

create_deps:
	bazel run @maven//:pin