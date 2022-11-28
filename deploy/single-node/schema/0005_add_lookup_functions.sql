-- +goose Up

CREATE FUNCTION HostToString AS(Sampler, Host) ->
    dictGetStringOrDefault('HostNames', 'Description', (IPv6NumToString(Sampler), Host), Host);
CREATE FUNCTION SamplerToString AS(Sampler) ->
    dictGetStringOrDefault('SamplerConfig', 'Description', IPv6NumToString(Sampler), Sampler);
CREATE FUNCTION ASNToString AS(ASN) ->
        substring(dictGetString('autnums', 'name', toUInt64(ASN)), 1, 25) || ' AS' || toString(ASN);
CREATE FUNCTION VLANToString AS(Sampler, VLAN) ->
        dictGetStringOrDefault('VlanNames', 'Description', (IPv6NumToString(Sampler), VLAN), VLAN);
CREATE FUNCTION InterfaceToString AS(Sampler, Interface) ->
    if(
            isNull(dictGetOrNull('InterfaceNames', 'Description', (IPv6NumToString(Sampler), Interface))),
            SamplerToString(Sampler) || ' - ' || toString(Interface),
            SamplerToString(Sampler) || ' - ' || toString(Interface) || ' [' ||
            dictGetString('InterfaceNames', 'Description', (IPv6NumToString(Sampler), Interface)) || ']'
        );

-- +goose Down

DROP FUNCTION HostToString;
DROP FUNCTION SamplerToString;
DROP FUNCTION InterfaceToString;
DROP FUNCTION ASNToString;
DROP FUNCTION VLANToString;