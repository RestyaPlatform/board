#!/bin/sh

export PGHOST=${POSTGRES_HOST}
export PGPORT=${POSTGRES_PORT}
export PGUSER=${POSTGRES_ADMIN_USER}
export PGPASSWORD=${POSTGRES_ADMIN_PASS}

DB_RESTYA_USER=${RESTYA_DB_USERNAME}
DB_RESTYA_PASS=${RESTYA_DB_USERPASS}
DB_RESTYA=${RESTYA_DB}

INIT_SQL_FILE="$ROOT_DIR/sql/restyaboard_with_empty_data.sql"

while :
do
    echo "Trying to connect to postgres ..."
    pg_isready
    if [ "$?" = 0 ]; then
        echo "Connection established!"
        break
    fi
    sleep 1s
done

if [ "$( psql -tAc "SELECT 1 FROM pg_database WHERE datname='$RESTYA_DB'" )" = '1' ]; then
    echo "Postgres database for restya already exists. (Database name: $RESTYA_DB). Skipping DB init."
    return 0
fi

echo "Creating PostgreSQL user and database..."

psql -c "DROP USER IF EXISTS ${DB_RESTYA_USER};CREATE USER ${DB_RESTYA_USER} WITH ENCRYPTED PASSWORD '${DB_RESTYA_PASS}'"
error_code=$?
if [ ${error_code} != 0 ]
then
    echo "PostgreSQL user creation failed with error code ${error_code} (PostgreSQL user creation failed with error code 35)"
    return 35
fi

psql -c "CREATE DATABASE ${RESTYA_DB} OWNER ${DB_RESTYA_USER} ENCODING 'UTF8' TEMPLATE template0"
error_code=$?
if [ ${error_code} != 0 ]
then
    echo "PostgreSQL database creation failed with error code ${error_code} (PostgreSQL database creation failed with error code 36)"
    return 36
fi

psql -c "CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;"
error_code=$?
if [ ${error_code} != 0 ]
then
    echo "PostgreSQL extension creation failed with error code ${error_code} (PostgreSQL extension creation failed with error code 37)"
    return 37
fi

psql -c "COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';"
error_code=$?
if [ ${error_code} != 0 ];
then
    echo "PostgreSQL extension comment failed with error code ${error_code}."
    return 38
fi

if [ -f "$INIT_SQL_FILE" ]
then
    echo "Importing empty SQL... (pipe output to /tmp/restya_initdb.log)"
    PGPASSWORD=$DB_RESTYA_PASS psql -d ${DB_RESTYA} -f "$ROOT_DIR/sql/restyaboard_with_empty_data.sql" -U ${DB_RESTYA_USER} > /tmp/restya_initdb.log
    
    if [ ${error_code} != 0 ]
    then
        echo "PostgreSQL Empty SQL importing failed with error code ${error_code} (PostgreSQL Empty SQL importing failed with error code 39)"
        return 39
    fi

    echo "Succesfully imported initial data."
else
    echo "Init SQL file does not exists. Maybe not mounted into correct place? Should be '$INIT_SQL_FILE'."
    return 40
fi