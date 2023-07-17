-- +goose Up
CREATE DATABASE dictionaries Engine=Dictionary;

-- +goose Down
DROP DATABASE dictionaries;