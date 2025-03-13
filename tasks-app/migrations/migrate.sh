#!/bin/sh
set -e

migrate -path /migrations -database "${DB_CONNECTION_STRING}&search_path=public&x-migrations-table=tasks_app_migrations" up
