#!/bin/sh
set -e

migrate -path /migrations -database $DB_CONNECTION_STRING up
