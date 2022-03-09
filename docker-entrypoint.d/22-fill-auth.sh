#!/bin/sh

set -e

ME=$(basename "$0")
HTPASSWD_FILE="/etc/nginx/auth.htpasswd"

fill_auth() {
    for ACC in $(env | grep '^ACCOUNT_'); do
        ACCOUNT_NAME=$(echo "${ACC}" | cut -d'=' -f1 | sed 's/ACCOUNT_//g')
        ACCOUNT_PASSWORD=$(echo "${ACC}" | sed 's/^[^=]*=//g')

        if echo "${ACCOUNT_PASSWORD}" | grep -q '^\$apr1'; then
            echo >&3 "${ME}: Adding account '${ACCOUNT_NAME}' with password in form of apr1 hash"
        else
            echo >&3 "${ME}: Adding account '${ACCOUNT_NAME}' - encrypting password"
            ACCOUNT_PASSWORD=$(echo "${ACCOUNT_PASSWORD}" | openssl passwd -apr1 -stdin)
        fi

        echo "${ACCOUNT_NAME}:${ACCOUNT_PASSWORD}" >> "${HTPASSWD_FILE}"
    done
}

fill_auth
