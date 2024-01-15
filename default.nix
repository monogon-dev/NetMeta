{ lib, buildGoModule }:
buildGoModule {
  name = "netmeta";

  src = ./.;

  subPackages = [
    "cmd/portmirror"
    "cmd/reconciler"
    "cmd/risinfo"
  ];

  vendorHash = "sha256-qGDNKOsOxu+7y2ycgebNSDFzbXZF2h9xFoHIf3U14Ao=";

  meta = with lib; {
    description = "A scalable network observability toolkit optimized for performance";
    homepage = "https://github.com/monogon-dev/NetMeta";
    license = licenses.asl20;
  };
}
