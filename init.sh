#!/bin/bash

set -eu

[ $# -lt 2 ] && echo "usage: $0 domain path [uuid]" && exit 1; 

INIT_HOME=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -f $INIT_HOME/config/v2ray.toml ] 
then
	echo "no config file" 
	exit 1
fi

domain=$1
path=$2
uuid="${3:-$(cat /proc/sys/kernel/random/uuid)}"

echo "init config with: domain: $domain, path: $path, uuid: $uuid"

DATA_HOME=$INIT_HOME/vol

mkdir -p $DATA_HOME/v2ray
sed 's/__UUID__/'"$uuid"'/' $INIT_HOME/config/v2ray.toml | sed 's/__PATH__/'"$path"'/' > $DATA_HOME/v2ray/config.toml

mkdir -p $DATA_HOME/caddy/web
sed 's/__DOMAIN__/'"$domain"'/' $INIT_HOME/config/Caddyfile | sed 's/__PATH__/'"$path"'/' > $DATA_HOME/caddy/Caddyfile

