#!/bin/sh

set -e

file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [[ ${!var:-} && ${!fileVar:-} ]]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [[ ${!var:-} ]]; then
        val="${!var}"
    elif [[ ${!fileVar:-} ]]; then
        val="$(< "${!fileVar}")"
    fi

    if [[ -n $val ]]; then
        export "$var"="$val"
    fi

    unset "$fileVar"
}

# Database configuration variables
file_env "DB_USERNAME"
file_env "DB_PASSWORD"
ile_env "DB_HOST"
file_env "DB_PORT"

# Keycloak integration variables
file_env "KEYCLOAK_CLIENT_ID"
file_env "KEYCLOAK_SECRET"
file_env "KEYCLOAK_TLS_VERIFICATION"
file_env "KEYCLOAK_HOST"
file_env "KEYCLOAK_PORT"

# Keycloak authentication string for password grant
file_env "KEYCLOAK_TEST_LOGIN"

# Start the server
exec /deployments/run-java.sh
