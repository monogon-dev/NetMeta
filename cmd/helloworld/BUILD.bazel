load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@io_bazel_rules_docker//go:image.bzl", "go_image")

go_library(
    name = "go_default_library",
    srcs = ["helloworld.go"],
    importpath = "github.com/leoluk/NetMeta/cmd/helloworld",
    visibility = ["//visibility:private"],
)

go_image(
    name = "helloworld",
    embed = [":go_default_library"],
    visibility = ["//visibility:public"],
)
