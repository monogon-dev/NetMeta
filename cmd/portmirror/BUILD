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
        "@com_github_google_gopacket//:gopacket",
        "@com_github_google_gopacket//afpacket",
        "@com_github_google_gopacket//layers",
        "@com_github_netsampler_goflow2//format:go_default_library",
        "@com_github_netsampler_goflow2//format/protobuf:go_default_library",
        "@com_github_netsampler_goflow2//pb:go_default_library",
        "@com_github_netsampler_goflow2//transport:go_default_library",
        "@com_github_netsampler_goflow2//transport/kafka:go_default_library",
        "@com_github_sirupsen_logrus//:logrus",
        "@com_github_vishvananda_netlink//:netlink",
    ],
)
