load("@io_bazel_rules_go//go:def.bzl", "go_library")
load("@io_bazel_rules_docker//go:image.bzl", "go_image")

go_library(
    name = "go_default_library",
    srcs = ["portmirror.go","frame.go","iface.go"],
    importpath = "github.com/leoluk/NetMeta/cmd/portmirror",
    visibility = ["//visibility:private"],
    deps = [
        "@com_github_cloudflare_goflow_v3//pb:go_default_library",
        "@com_github_cloudflare_goflow_v3//transport:go_default_library",
        "@com_github_google_gopacket//:go_default_library",
        "@com_github_google_gopacket//afpacket:go_default_library",
        "@com_github_google_gopacket//layers:go_default_library",
        "@com_github_prometheus_procfs//sysfs:go_default_library",
        "@com_github_sirupsen_logrus//:go_default_library",
    ],
)

go_image(
    name = "portmirror",
    embed = [":go_default_library"],
    visibility = ["//visibility:public"],
)
