#!/bin/sh
# wait-for-mariadb-init.sh

set -e
  
host="$1"
shift
cmd="$@"
  
until PASSWORD=${MARIADB_PASSWORD} mysql -u ${MYSQL_USER} --password="${MYSQL_PASSWORD}" ${MYSQL_DATABASE} -h "db" -e "select 1"; do
  >&2 echo "Mariadb is not initialized"
  sleep 5
done

>&2 echo "Mariadb Has Been Initialized"
