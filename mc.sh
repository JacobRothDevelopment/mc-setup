#!/bin/bash

#region CONSTANTS
VERSION="0.3.0"

cyan='\e[36m'
red='\e[31m'
yellow='\e[93m'
no_color='\e[0m'

XMX="1024M"
XMS="1024M"
debug_mode=0
dry_run_mode=0
do_gui="n"
#endregion

#region FUNCTIONS
debug() {
    if [ $debug_mode -gt 0 ]; then
        echo -e "${cyan}$1${no_color}"
    fi
}
error() { echo -e "${red}$1${no_color}"; }
warn() { echo -e "${yellow}$1${no_color}"; }

echo_help() {
    echo -e "\t${1}\t${2}"
}

usage() {
    echo_help "Usage:" "$0 [verb] [options]"
    echo_help "Usage:" "$0 start -w <string>"
    echo_help "Help:" "$0 -h"
}

inputs() {
    echo "verbs"
    echo_help "help" "Help menu"
    echo_help "list" "List available servers"
    echo_help "start" "Start given server [-w required]"

    echo "options"
    echo_help "-d" "Debug mode - will not start minecraft server"
    echo_help "-g" "Set GUI mode <y|n> (default n)"
    echo_help "-h" "Help menu"
    echo_help "-s" "XMS - minimum memory value (default 1024M)"
    echo_help "-v" "Script version"
    echo_help "-w" "World directory name (required)"
    echo_help "-x" "XMX - maximum memory value (default 1024M)"
}
#endregion

#region CAPTURE OPERATION

operation=$1
shift 1

#endregion

#region CAPTURE FLAGS
while getopts "w:g:x:s:hdvr" flag; do
    case $flag in
    v)
        echo $VERSION
        exit 0
        ;;
    w) world=$OPTARG ;;
    g) do_gui=$OPTARG ;;
    h)
        usage
        inputs
        exit 0
        ;;
    x) XMX=$OPTARG ;;
    s) XMS=$OPTARG ;;
    d)
        debug_mode=1
        warn "using debug mode"
        ;;
    r) dry_run_mode=1 ;;
    *)
        usage
        inputs
        exit 1
        ;;
    esac
done
#endregion

case $operation in
"list")
    # ls -d */ | sed 's#/##'
    find * -maxdepth 1 -mindepth 1 -type f -name 'server.jar' -print0 | xargs -0 -- dirname
    ;;
"start")
    #region ENSURE VALID ENTRIES FOR CERTAIN FLAGS
    if [[ -z $world || -z $do_gui ]]; then
        error "Invalid options for start"
        usage
        inputs
        exit 1
    fi

    gui="nogui"
    if [[ $do_gui = "y" ]]; then
        gui=""
    fi
    #endregion

    debug "world    $world"
    debug "gui      $gui"
    debug "XMX      $XMX"
    debug "XMS      $XMS"

    if [ $dry_run_mode -gt 0 ]; then
        warn "server is not started in dry run mode"
        echo "commands for server startup"
        echo "cd $world"
        echo "java -Xmx$XMX -Xms$XMS -jar server.jar $gui"
    else
        cd $world
        # example: java -Xmx1024M -Xms1024M -jar minecraft_server.1.19.3.jar nogui
        java -Xmx$XMX -Xms$XMS -jar server.jar $gui
    fi
    ;;

*)
    error "Invalid operation"
    usage
    inputs
    exit 1
    ;;
esac
