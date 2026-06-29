#!/bin/bash

#region CONSTANTS

set -euo pipefail

VERSION="0.1.1"

cyan='\e[36m'
red='\e[31m'
green='\e[32m'
yellow='\e[93m'
no_color='\e[0m'

#endregion

info() { echo -e "${cyan}$1${no_color}"; }
success() { echo -e "${green}$1${no_color}"; }
error() { echo -e "${red}$1${no_color}"; }
warn() { echo -e "${yellow}$1${no_color}"; }

case $1 in
    "list")
        if ! command -v java > /dev/null 2>&1; then
            warn "No Java versions are installed"
            exit
        fi

        info "Installed Java version"
        update-alternatives --list java
        info "\nJava binaries in /bin"
        find /bin/java*
        info "\nCurrent default Java version"
        java --version
    ;;
    "install")
        if [ -z $2 ]; then
            error "Provide an installation version in position 2"
            exit 1
        fi
        sudo apt install openjdk-$2-jre-headless
        sudo ln -sf /usr/lib/jvm/java-$2-openjdk-amd64/bin/java /bin/java$2
        success "New Java version available at /bin/java$2"
    ;;
    *)
        error "provide 'install' or 'list' in position 1"
    ;;
esac
