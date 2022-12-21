load("@io_bazel_rules_docker//go:image.bzl", "go_image")

go_image(
    name = "portmirror",
    srcs = [
        "frame.go",
        "iface.go",
        "portmirror.go",
    ],
    importpath = "github.com/monogon-dev/NetMeta/cmd/portmirror",
    static = "on",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_cloudflare_goflow_v3//pb:go_default_library",
        "@com_github_cloudflare_goflow_v3//transport:go_default_library",
        "@com_github_google_gopacket//:go_default_library",
        "@com_github_google_gopacket//afpacket:go_default_library",
        "@com_github_google_gopacket//layers:go_default_library",
        "@com_github_sirupsen_logrus//:go_default_library",
        "@com_github_vishvananda_netlink//:go_default_library",
    ],
)
