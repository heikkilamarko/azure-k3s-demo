#!/bin/bash
set -e

kubectl create secret generic tasks-app-secret --from-literal=TASKS_APP_CONNECTIONSTRING="postgres://$1:$2@$3:5432/demo?sslmode=require"
