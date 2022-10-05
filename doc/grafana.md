# Grafana
## Exporting Dashboards
It is possible to export all Grafana dashboards to JSON files for easier import into a self-managed Grafana instance.
Use the following command to dump all dashboards:
```
~/NetMeta/deploy $ cue dump_dashboards ./...
```

## FastNetMon Integration

NetMeta supports displaying FastNetMon attack notifications if a FastNetMon InfluxDB datasource is available in the same Grafana instance.

To configure FastNetMon to write attack notifications you have to enable them via:
```
sudo fcli set main influxdb_attack_notification enable
sudo fcli commit
```

More infos are available in the FastNetMon docs: https://fastnetmon.com/docs-fnm-advanced/fastnetmon-attack-notification-in-grafana/
