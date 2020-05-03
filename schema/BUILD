load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@io_bazel_rules_docker//container:image.bzl", "container_image")

go_library(
    name = "go_default_library",
    srcs = ["include.go"],
    importpath = "github.com/leoluk/NetMeta/schema",
    visibility = ["//visibility:public"],
    deps = ["@com_github_golang_migrate_migrate_v4//cmd/migrate:go_default_library"],
)

container_image(
    name = "migrate",
    base = "@go_image_base//image",
    cmd = ["/migrate"],
    files = ["@com_github_golang_migrate_migrate_v4//cmd/migrate"],
    legacy_run_behavior = False,
    user = "nonroot",
)
