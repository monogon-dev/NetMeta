# How to update dashboards

Rather than building dashboards entirely from scratch like grafonnet does, we try to stay as close to the exported JSON
structure as possible, augmenting it with Cue constructs as needed. This allows us to use templating without losing the
convenience of modifying dashboards using the web editor.

In order to update the dashboard template from an export, copy the exported to this directory, run `clean.sh` to remove
a number of known sources of noisy diffs, and use a competent whitespace-tolerant diff viewer like IntelliJ's to compare
the resulting Cue file to the template and cherry-pick changes.

When iterating on the template, you can use `./poke-grafana-with-a-stick.sh` in the grafana deployment folder, which
short-circuits the ConfigMap update for faster refreshs.
