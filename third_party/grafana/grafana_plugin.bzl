load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@io_bazel_rules_docker//container:container.bzl", "container_layer")

_grafana_plugin_attrs = {
    "version": attr.string(
        mandatory = True,
        doc = "The plugin version to download and bundle",
    ),
}

def _grafana_plugin_impl(ctx):
    ctx.download_and_extract(
        url = "https://grafana.com/api/plugins/%s/versions/%s/download?os=%s&arch=%s" % (ctx.name, ctx.attr.version, os(ctx), arch(ctx)),
        type = "zip",
    )

    ctx.file("BUILD.bazel", """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "files",
    srcs = glob(["**"]),
)
    """)

grafana_plugin = repository_rule(
    attrs = _grafana_plugin_attrs,
    implementation = _grafana_plugin_impl,
)

def os(rctx):
    os = rctx.os.name.lower()
    if os == "mac os x":
        return "darwin"
    return os

def arch(rctx):
    arch = rctx.os.arch.lower()
    if arch == "aarch64":
        return "arm64"
    return arch
