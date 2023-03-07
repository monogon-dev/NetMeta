load("@bazel_gazelle//:def.bzl", "gazelle")
load("@io_bazel_rules_go//go:def.bzl", "go_path", "nogo")
load("@io_bazel_rules_docker//container:bundle.bzl", "container_bundle")
load("@io_bazel_rules_docker//contrib:push-all.bzl", "container_push")

# gazelle:prefix github.com/monogon-dev/NetMeta
# gazelle:exclude deploy
# gazelle:exclude third_party/tools
gazelle(name = "gazelle")

# Shortcut for the Go SDK
alias(
    name = "go",
    actual = "@go_sdk//:bin/go",
    visibility = ["//visibility:public"],
)

_CONTAINERS = {
    "helloworld": "//cmd/helloworld:helloworld",
    "risinfo": "//cmd/risinfo:risinfo",
    "portmirror": "//cmd/portmirror:portmirror",
    "reconciler": "//cmd/reconciler:reconciler",
    "goflow": "//third_party/goflow:goflow",
    "grafana": "//third_party/grafana:grafana",
}

container_bundle(
    name = "netmeta_containers",
    images = {
        ("ghcr.io/monogon-dev/netmeta/{}".format(k) + ":{COMMIT_GIT_SHA}"): v
        for k, v in _CONTAINERS.items()
    },
)

container_push(
    name = "push",
    bundle = ":netmeta_containers",
    format = "Docker",
)
