load("@io_bazel_rules_docker//container:container.bzl", "container_image", "container_layer")

PLUGINS = {
    "netsage-sankey-panel": "1.0.6",
    "grafana-clickhouse-datasource": "2.0.7",
}

def grafana_plugin_layer(name):
    container_layer(
        name = name,
        files = [
            "@{}//:files".format(name),
        ],
        data_path = ".",
        directory = "/var/lib/grafana/plugins/{}".format(name),
    )

    return ":{}".format(name)

def grafana_image():
    container_image(
        name = "grafana",
        base = "@grafana//image",
        layers = [grafana_plugin_layer(name) for name, _ in PLUGINS.items()],
        visibility = ["//visibility:public"],
    )
