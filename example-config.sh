#!/usr/bin/env bash
# Generate an example deploy/single-node/config_local.cue file

function mkpw() {
  head -c $1 /dev/random | base64
}

# Don't forget to update the copy in README when changing this.

cat <<EOF
package k8s

netmeta: config: {
    grafanaInitialAdminPassword: "$(mkpw 18)"
    clickhouseAdminPassword:     "$(mkpw 18)"
    clickhouseReadonlyPassword:  "$(mkpw 18)"
    sessionSecret:               "$(mkpw 32)"

    publicHostname: "$(hostname -f)"

    letsencryptMode:        "staging"  // change to "production" later
    letsencryptAccountMail: "letsencrypt@example.com"
}
EOF
