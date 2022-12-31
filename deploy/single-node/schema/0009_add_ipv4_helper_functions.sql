-- +goose Up

CREATE FUNCTION toIPv6Net AS(Net) ->
    if(
            isIPv4String(splitByChar('/', Net)[1]),
            '::ffff:' || arrayStringConcat(
                    arrayMap((v, i) -> if(i, toString(toInt8(v) + 96), v), splitByChar('/', Net), [false, true]),
                    '/'),
            Net
        );

CREATE FUNCTION IPv6ToString AS(Address) ->
    if(
            startsWith(Address, repeat('\x00', 10) || repeat('\xff', 2)),
            IPv4NumToString(reinterpret(reverse(substr(Address, 13, 16)), 'IPv4')),
            IPv6NumToString(Address)
        );

CREATE OR REPLACE FUNCTION HostToString AS(Sampler, Host) ->
    dictGetStringOrDefault('HostNames', 'Description', (IPv6NumToString(Sampler), Host), IPv6ToString(Host));

-- +goose Down

DROP FUNCTION toIPv6Net;
DROP FUNCTION IPv6ToString;

CREATE OR REPLACE FUNCTION HostToString AS(Sampler, Host) ->
    dictGetStringOrDefault('HostNames', 'Description', (IPv6NumToString(Sampler), Host), Host);