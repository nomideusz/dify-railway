#!/bin/bash
set -e

# Runs once on first boot (empty PGDATA). The api service creates its own
# tables via migrations; the plugin daemon expects its database to exist.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS vector;
    CREATE DATABASE dify_plugin;
EOSQL
