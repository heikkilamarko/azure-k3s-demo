#!/bin/bash
set -e

echo "shared_preload_libraries = 'pg_cron'" >> /var/lib/postgresql/data/postgresql.conf
echo "cron.use_background_workers = on" >> /var/lib/postgresql/data/postgresql.conf
