#!/bin/sh

set -e
DIR_TMP="$(mktemp -d)"

# Install alist
wget -O - https://github.com/alist-org/alist/releases/latest/download/alist-linux-musl-amd64.tar.gz | tar -zxf - -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/alist /usr/bin/

# install cloudflared
busybox wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/download/2023.5.0/cloudflared-linux-amd64
chmod +x /usr/bin/argo 

rm -rf ${DIR_TMP}
