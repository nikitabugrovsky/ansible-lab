#!/usr/bin/env bash

AUTHORIZED_KEYS_FILE="/home/vagrant/.ssh/authorized_keys"
REGEXP_TO_MATCH="vagrant@control-node"
PUB_KEY_CONTENT="$1"

function key_installed() {
    grep -q "$REGEXP_TO_MATCH" "$AUTHORIZED_KEYS_FILE" &&  \
    echo "Key is present. Nothing to do. Exiting..." || \
    (echo "Key is not installed."; exit 1)
}

function distribute_key() {
    echo "$PUB_KEY_CONTENT" >> "$AUTHORIZED_KEYS_FILE"
}

if ! key_installed; then
    distribute_key
fi