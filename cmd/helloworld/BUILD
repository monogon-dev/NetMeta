load("@io_bazel_rules_docker//go:image.bzl", "go_image")

go_image(
    name = "helloworld",
    srcs = ["helloworld.go"],
    importpath = "github.com/monogon-dev/NetMeta/cmd/helloworld",
    static = "on",
    visibility = ["//visibility:public"],
)
