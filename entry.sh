#!/usr/bin/env bash
set -ue

DATA=${DATA_DIR:-/data}
PORT=${DB_PORT:-5432}

# Wait for postgres
export PGPASSWORD=${DB_PASS}
while ! psql -h "${DB_HOST}" -U "${DB_USER}" -p "${PORT}" -c 'select 1' "${DB_NAME}" &> /dev/null ; do
  echo "Waiting for postgres to be available..."
  sleep 1
done

# Wait 3 more seconds for postgres to restart itself
sleep 3


# Run confd to update config templates with environment variables
confd -onetime -backend env -log-level error


# Check if DB needs to be initialized
DB_INITIALIZED_MARKER="${DATA}/core/.db-initialized"

if [ ! -f ${DB_INITIALIZED_MARKER} ]; then
    echo "initializing core db..."
    stellar-core --conf /stellar-core.cfg -newdb
    mkdir -p ${DATA}/core
    touch ${DB_INITIALIZED_MARKER}
fi


echo "starting stellar-core..."
exec "$@"