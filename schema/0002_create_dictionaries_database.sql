-- +goose Up
CREATE DATABASE IF NOT EXISTS dictionaries Engine=Dictionary;

-- +goose Down
DROP DATABASE dictionaries;