load("@io_bazel_rules_docker//container:image.bzl", "container_image")

container_image(
    name = "migrate",
    base = "@go_image_base//image",
    cmd = ["/migrate"],
    files = [
        ":migrations",
        "@com_github_golang_migrate_migrate_v4//cmd/migrate",
    ],
    legacy_run_behavior = False,
    user = "nonroot",
)

filegroup(
    name = "migrations",
    srcs = glob(["*.sql"]),
)
