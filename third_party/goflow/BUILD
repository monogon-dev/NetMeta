load("@io_bazel_rules_docker//go:image.bzl", "go_image")

go_image(
    name = "goflow",
    binary = "@com_github_netsampler_goflow2//cmd/goflow2:goflow2",
    static = "on",
    visibility = ["//visibility:public"],
)
