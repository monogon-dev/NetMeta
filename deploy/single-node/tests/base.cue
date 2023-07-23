package tests

import netmeta "github.com/monogon-dev/NetMeta/deploy/single-node:k8s"

test: [string]: T={
	config:  netmeta.#NetMetaConfig
	out:     (netmeta & {netmeta: config: T.config})
	asserts: true
}

_requiredDefaults: {
	grafanaInitialAdminPassword: "grafanaInitialAdminPassword"
	clickhouseAdminPassword:     "clickhouseAdminPassword"
	clickhouseReadonlyPassword:  "clickhouseReadonlyPassword"
	sessionSecret:               "sessionSecret"

	publicHostname: "publicHostname"
}

test: "traefik: letsencrypt: off": T={
	config: {
		_requiredDefaults
		letsencryptMode: "off"
	}

	asserts: T.out.k8s.Deployment.traefik.spec.template.spec.containers[0].args == ["--accesslog", "--entrypoints.web.Address=:80", "--entrypoints.websecure.Address=:443", "--providers.kubernetescrd"]
}

test: "traefik: letsencrypt: staging": T={
	config: {
		_requiredDefaults
		letsencryptMode: "staging"
		letsencryptAccountMail: "letsencrypt@example.com"
	}

	asserts: T.out.k8s.Deployment.traefik.spec.template.spec.containers[0].args == ["--accesslog", "--entrypoints.web.Address=:80", "--entrypoints.websecure.Address=:443", "--providers.kubernetescrd", "--certificatesresolvers.publicHostnameResolver.acme.tlschallenge", "--certificatesresolvers.publicHostnameResolver.acme.email=letsencrypt@example.com", "--certificatesresolvers.publicHostnameResolver.acme.storage=/data/acme-staging.json", "--certificatesresolvers.publicHostnameResolver.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory"]
}

test: "traefik: letsencrypt: production": T={
	config: {
		_requiredDefaults
		letsencryptMode: "production"
		letsencryptAccountMail: "letsencrypt@example.com"
	}

	asserts: T.out.k8s.Deployment.traefik.spec.template.spec.containers[0].args == ["--accesslog", "--entrypoints.web.Address=:80", "--entrypoints.websecure.Address=:443", "--providers.kubernetescrd", "--certificatesresolvers.publicHostnameResolver.acme.tlschallenge", "--certificatesresolvers.publicHostnameResolver.acme.email=letsencrypt@example.com", "--certificatesresolvers.publicHostnameResolver.acme.storage=/data/acme-production.json"]
}


test: "clickhouse: minimal config": T={
	config: {
		_requiredDefaults
		letsencryptMode: "off"
	}

	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."InterfaceNames.tsv" == ""
	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."SamplerConfig.tsv" == ""
}

test: "clickhouse: empty sampler": T={
	config: {
		_requiredDefaults
		letsencryptMode: "off"

		sampler: "::ffff:100.0.0.1": {
		}
	}

	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."InterfaceNames.tsv" == ""
	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."SamplerConfig.tsv" == "::ffff:100.0.0.1\tNULL\tNULL\tfalse"
}

test: "clickhouse: sampler with desc": T={
	config: {
		_requiredDefaults
		letsencryptMode: "off"

		sampler: "::ffff:100.0.0.1": {
			description: "foo"
		}
	}

	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."InterfaceNames.tsv" == ""
	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."SamplerConfig.tsv" == "::ffff:100.0.0.1\tNULL\tfoo\tfalse"
}

test: "clickhouse: sampler with interface": T={
	config: {
		_requiredDefaults
		letsencryptMode: "off"

		sampler: "::ffff:100.0.0.1": {
			interface: "858": description: "TRANSIT-ABC"
		}

	}
	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."InterfaceNames.tsv" == "::ffff:100.0.0.1\t858\tTRANSIT-ABC"
	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."SamplerConfig.tsv" == "::ffff:100.0.0.1\tNULL\tNULL\tfalse"
}

test: "clickhouse: sampler with desc and interfaces": T={
	config: {
		_requiredDefaults
		letsencryptMode: "off"

		sampler: "::ffff:100.0.0.1": {
			description: "foo"
			interface: "858": description: "TRANSIT-ABC"
		}
	}

	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."InterfaceNames.tsv" == "::ffff:100.0.0.1\t858\tTRANSIT-ABC"
	asserts: T.out.k8s.ClickHouseInstallation.netmeta.spec.configuration.files."SamplerConfig.tsv" == "::ffff:100.0.0.1\tNULL\tfoo\tfalse"
}
