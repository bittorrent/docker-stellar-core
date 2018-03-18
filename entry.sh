#!/usr/bin/env bash
set -ue

: ${DATA_DIR:=/data}
: ${DB_PORT:=5432}

# Wait for postgres
export PGPASSWORD=${DB_PASS}
while ! psql -h "${DB_HOST}" -U "${DB_USER}" -p "${DB_PORT}" -c 'select 1' "${DB_NAME}" &> /dev/null ; do
  echo "Waiting for postgres to be available..."
  sleep 5
done

# Wait 5 more seconds for postgres to restart itself
sleep 5


# Run confd to update config templates with environment variables
confd -onetime -backend env -log-level error


# Check if DB needs to be initialized
DB_INITIALIZED_MARKER="${DATA_DIR}/core/.db-initialized"

if [ ! -f ${DB_INITIALIZED_MARKER} ]; then
    echo "initializing core db..."
    stellar-core --conf /stellar-core.cfg -newdb
    mkdir -p ${DATA_DIR}/core
    touch ${DB_INITIALIZED_MARKER}
fi


echo "starting stellar-core..."
exec "$@"