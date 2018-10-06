#!/usr/bin/env bash

# this script installs ansible control node

function platform_supported() {
    local release_file="/etc/redhat-release" 
    [ -f "$release_file" ] && echo "Platform supported" || (echo "Platform is not supported. Exiting..."; exit 1)
}

function enable_epel_repo() {
    local repo_name="epel-release" 
    yum list installed "$repo_name"
    if [ "$?" -eq 1 ]; then
        echo "$repo_name is not enabled"
        install_package "$repo_name"
    fi
}

function install_ansible() {
    local package="ansible" 
    yum list installed "$package"
    if [ "$?" -eq 1 ]; then 
        echo "$package is not installed"
        install_package "$package"
    fi
}

function install_package() { 
    yum install "$@" -y
}

if platform_supported; then
    enable_epel_repo && install_ansible
fi