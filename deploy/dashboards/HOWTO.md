# How to update dashboards

Rather than building dashboards entirely from scratch like grafonnet does, we try to stay as close to the exported JSON
format as possible, augmenting it with Cue constructs as needed. This works because Cue is a strict superset of JSON,
allowing for templating without losing the convenience of modifying dashboards using the web editor.

In order to update the dashboard template from an export, copy the exported to this directory, run `clean.sh` to remove
a number of known sources of noisy diffs, and use a competent whitespace-tolerant diff viewer like IntelliJ's to compare
the export to the Cue file and cherry-pick changes from the export to the template.

When iterating on the template, you can use `./poke-grafana-with-a-stick.sh` in the grafana deployment folder, which
short-circuits the ConfigMap update for faster refreshs.
