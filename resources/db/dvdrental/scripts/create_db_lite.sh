#!/usr/bin/env bash

echo "PGHOST ${PGHOST}"
echo "PGPORT ${PGPORT}"
echo "PGDATABASE ${PGDATABASE}"
echo "PGUSER ${PGUSER}"
echo "PGPASSWORD ${PGPASSWORD}"

echo "DVDDBOWNER ${DVDDBOWNER}"
echo "DVDDBOWNERPASSWORD ${DVDDBOWNERPASSWORD}"
echo "DVDDATABASE ${DVDDATABASE}"


export SCRIPT_DIR=$(dirname "$0")
echo "SCRIPT_DIR ${SCRIPT_DIR}"


echo "Executing User/DB SQL Commands..."

psql -U ${PGUSER} <<END_OF_SQL
do $$
declare
    dvd_db_owner_exists boolean default false;
    dvd_db_exists boolean default false;
begin
select exists (select 1 from pg_catalog.pg_roles where lower(rolname) = lower(${DVDDBOWNER})) into dvd_db_owner_exists;
if not dvd_db_owner_exists then
    create role lower(${DVDDBOWNER}) with login superuser inherit createdb createrole noreplication nobypassrls;
end if;

select exists (select 1 from pg_catalog.pg_database db where lower(db.datname) = lower(${DVDDATABASE})) into dvd_db_exists;
if dvd_db_exists then
    drop database lower(${DVDDATABASE});
end if;
create database lower(${DVDDATABASE}) with owner lower(${DVDDBOWNER});
end;
$$;
END_OF_SQL

echo "Completed User/DB SQL Command Execution"

# createdb -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} -O ${DB_OWNER} ${POSTGRES_DATABASE}

psql -U ${PGUSER} -c "\l"

# psql -U ${PGUSER} -d ${DVDDATABASE} < ./restore.sql

psql -U ${PGUSER} -d ${DVDDATABASE} -c "\c ${DVDDATABASE}" -c "\dt"
