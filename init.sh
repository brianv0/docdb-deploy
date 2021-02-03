#!/bin/bash
export DB_PASSWORD=$(openssl rand -base64 12)
export DB_ROOT_PASSWORD=$(openssl rand -base64 12)

docker-compose -f docker-compose-init.yml up --abort-on-container-exit --exit-code-from wait-for-init

echo "User is: ${DB_USER}"
echo "Password is: ${DB_PASSWORD}"
echo "Root Password is: ${DB_ROOT_PASSWORD}"
echo "Database is: ${DB_NAME}"

if [[ $_ != $0 ]]; then
  echo "Exporting DB_NAME, DB_RWUSER, DB_ROUSER, DB_RWPASSWORD, DB_ROPASSWORD"
  export DB_NAME=${DB_NAME}
  export DB_RWUSER=${DB_USER}
  export DB_ROUSER=${DB_USER}
  export DB_RWPASSWORD=${DB_PASSWORD}
  export DB_ROPASSWORD=${DB_PASSWORD}
fi
