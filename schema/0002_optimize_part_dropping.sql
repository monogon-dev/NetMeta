-- +goose Up
ALTER TABLE flows_raw MODIFY SETTING ttl_only_drop_parts=1, materialize_ttl_recalculate_only=1;

-- +goose Down
ALTER TABLE flows_raw RESET SETTING ttl_only_drop_parts, materialize_ttl_recalculate_only;