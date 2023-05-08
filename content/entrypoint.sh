#!/bin/bash

exec 2>&1

PARSE_DB_URL() {
    # extract the protocol
    proto="$(echo $DATABASE_URL | grep '://' | sed -e's,^\(.*://\).*,\1,g')"
    if [[ "${proto}" =~ postgres ]]; then
        export DB_TYPE=postgres
        export DB_SSL_MODE=require
    elif [[ "${proto}" =~ mysql ]]; then
        export DB_TYPE=mysql
        export DB_SSL_MODE=true
    fi

    # remove the protocol
    url=$(echo $DATABASE_URL | sed -e s,${proto},,g)

    # extract the user and password (if any)
    userpass="$(echo $url | grep @ | cut -d@ -f1)"
    export DB_PASS=$(echo $userpass | grep : | cut -d: -f2)
    if [ -n "$DB_PASS" ]; then
        export DB_USER=$(echo $userpass | grep : | cut -d: -f1)
    else
        export DB_USER=$userpass
    fi

    # extract the host -- updated
    hostport=$(echo $url | sed -e s,$userpass@,,g | cut -d/ -f1)
    export DB_PORT=$(echo $hostport | grep : | cut -d: -f2)
    if [ -n "$DB_PORT" ]; then
        export DB_HOST=`echo $hostport | grep : | cut -d: -f1`
    else
        export DB_HOST=$hostport
    fi

    # extract the name (if any)
    export DB_NAME="`echo $url | grep / | cut -d/ -f2- | sed 's|?.*||'`"
}

if [ "${DATABASE_URL}" != "" ]; then
    PARSE_DB_URL
fi

cd /tmp

echo $ArgoJSON > /tmp/argo.json
ARGOID="$(jq .TunnelID /tmp/argo.json | sed 's/\"//g')"
cp /workdir/argo.yml /tmp/argo.yml
sed -i "s|ARGOID|${ARGOID}|" /tmp/argo.yml

alist server --no-prefix &

exec argo --loglevel fatal tunnel -config /tmp/argo.yml run ${ARGOID} 2>&1 >/dev/null