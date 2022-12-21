load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@io_bazel_rules_docker//go:image.bzl", "go_image")

go_image(
    name = "goflow",
    binary = "@com_github_cloudflare_goflow_v3//cmd/goflow:goflow",
    static = "on",
    visibility = ["//visibility:public"],
)

go_library(
    name = "go_default_library",
    srcs = ["binaries.go"],
    importpath = "github.com/monogon-dev/NetMeta/third_party/goflow",
    visibility = ["//visibility:public"],
    deps = ["@com_github_cloudflare_goflow_v3//cmd/goflow:go_default_library"],
)
