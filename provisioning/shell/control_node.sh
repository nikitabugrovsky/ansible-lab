#!/usr/bin/env bash

# this script installs ansible control node

ANSIBLE_PACKAGE="ansible"
EPEL_REPO_PACKAGE="epel-release"
PLATFORM_RELEASE_FILE="/etc/redhat-release"
ANSIBLE_HOSTS_FILE="/etc/ansible/hosts"
ANSIBLE_NODES=("$@")

function platform_supported() {
    [ -f "$PLATFORM_RELEASE_FILE" ] && \
    echo "Platform supported" || \
    (echo "Platform is not supported. Exiting..."; exit 1)
}

function enable_epel_repo() {
    check_installed "$EPEL_REPO_PACKAGE"
    if [ "$?" -eq 1 ]; then
        echo "$EPEL_REPO_PACKAGE is not enabled"
        install_package "$EPEL_REPO_PACKAGE"
    fi
}

function install_ansible() {
    check_installed "$ANSIBLE_PACKAGE"
    if [ "$?" -eq 1 ]; then 
        echo "$ANSIBLE_PACKAGE is not installed"
        install_package "$ANSIBLE_PACKAGE"
    fi
}

function check_installed() { 
    yum list installed "$@"
}

function install_package() { 
    yum install "$@" -y
}

function add_ansible_nodes() {
    for node in "${ANSIBLE_NODES[@]}"; do
        grep -q "$node" "$ANSIBLE_HOSTS_FILE" && \
        (echo "$host is already added to $ANSIBLE_HOSTS_FILE"; exit 1) \
        || echo "$node" >> "$ANSIBLE_HOSTS_FILE"
    done
}

if platform_supported; then
    enable_epel_repo && \
    install_ansible && \
    add_ansible_nodes
fi