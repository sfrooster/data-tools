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

# psql -U username -d database_name -h hostname -p port_number < /path/to/your/script.sql
# psql --set=my_psql_var="${MY_VARIABLE}" -f your_script.sql
psql -U ${PGUSER} \
    --set=dvddatabase="$(echo ${DVDDATABASE} | tr '[:upper:]' '[:lower:]')" \
    --set=pguser="$(echo ${PGUSER} | tr '[:upper:]' '[:lower:]')" \
    --set=scriptdir="${SCRIPT_DIR}" \
    -f ./restore_dyn.sql

echo "Completed User/DB SQL Command Execution"


psql -U ${PGUSER} -c "\l"
psql -U ${PGUSER} -d ${DVDDATABASE} -c "\c ${DVDDATABASE}" -c "\dt"
