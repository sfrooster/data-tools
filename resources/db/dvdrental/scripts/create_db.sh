#!/usr/bin/env bash

echo ${POSTGRES_HOST}
echo ${POSTGRES_PORT}
echo ${POSTGRES_DATABASE}
echo ${POSTGRES_USER}
echo ${POSTGRES_PASSWORD}
echo ${DB_OWNER}

export SCRIPT_DIR=$(dirname "$0")
echo ${SCRIPT_DIR}

createdb -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} -O ${DB_OWNER} ${POSTGRES_DATABASE}

psql -U ${POSTGRES_USER} -c "\l"

psql -U ${POSTGRES_USER} -d ${POSTGRES_DATABASE} < ./restore.sql

psql -U ${POSTGRES_USER} -c "\c dvdrental" -c "\dt"
