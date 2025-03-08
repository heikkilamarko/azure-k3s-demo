#!/bin/sh
set -e

migrate -path /migrations -database $TASKS_APP_CONNECTIONSTRING up
