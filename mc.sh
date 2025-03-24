#!/bin/bash

#region CONSTANTS
VERSION="0.3.0"

cyan='\e[36m'
red='\e[31m'
yellow='\e[93m'
no_color='\e[0m'

XMX="1024M" # maximum memory value
XMS="1024M" # minimum memory value
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
    echo_help "-h" "Help menu"
    echo_help "-v" "Script version"
    echo_help "-w" "World directory name (required for start|backup)"
}

echo_default_run_sh() {
    ret="echo -e \"\e[31m$world/run.sh hasn't been approved to run yet\e[0m\"\n"
    ret+="exit 1\n"
    ret+="# remove the above lines to approve the script to run\n\n"
    ret+="java -server -Xmx$XMX -Xms$XMS -jar server.jar nogui"
    echo "$ret"
}
#endregion

#region CAPTURE OPERATION

operation=$1
shift 1

#endregion

#region CAPTURE FLAGS
while getopts "w:hdvr" flag; do
    case $flag in
    v)
        echo $VERSION
        exit 0
        ;;
    w) world=$OPTARG ;;
    h)
        usage
        inputs
        exit 0
        ;;
    d)
        debug_mode=1
        warn "using debug mode"
        ;;
    r)
        dry_run_mode=1
        warn "using dry run mode"
        ;;
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
    debug "listing server"
    # ls -d */ | sed 's#/##'
    # find * -maxdepth 1 -mindepth 1 -type f -name 'server.jar' -print0 | xargs -0 -- dirname
    find * -maxdepth 1 -mindepth 1 -type f -name 'run.sh' -print0 | xargs -0 -- dirname
    ;;
"backup")
    debug "starting backup of $world"

    # validate required flags
    if [[ -z $world ]]; then
        error "Invalid options for start"
        usage
        inputs
        exit 1
    fi

    date="$(date +%Y%m%d-%H%M%S)"
    backup_file="backups/$world-$date.tar.gz"

    if [ $dry_run_mode -gt 0 ]; then
        warn "Backup not created in dry run mode"
        echo "Command for server backup:"
        echo "mkdir \$(dirname $backup_file)"
        echo "tar -czvf $backup_file $world"
    else
        # stolen from https://stackoverflow.com/a/62007533
        mkdir $(dirname $backup_file)
        tar -czvf $backup_file $world
        echo "Server backup created at $backup_file"
    fi
    ;;
"start")
    debug "starting server $world"

    # validate required flags
    if [[ -z $world ]]; then
        error "Invalid options for start"
        usage
        inputs
        exit 1
    fi

    start_script="$world/run.sh"

    if [ -e $start_script ]; then
        if [ $dry_run_mode -gt 0 ]; then
            warn "server is not started in dry run mode"
            echo "Commands for server startup:"
            echo "cd $world"
            echo "bash run.sh"
        else
            cd $world
            bash run.sh
            # example: java -Xmx1024M -Xms1024M -jar minecraft_server.1.19.3.jar nogui
            # java -Xmx$XMX -Xms$XMS -jar server.jar nogui
        fi
    else
        error "Server startup script does not exist"

        if [ $dry_run_mode -gt 0 ]; then
            warn "File not created in dry run mode"
            warn "This is the run.sh file that would have been created"
            echo -e $(echo_default_run_sh)
        else
            warn "Creating default run.sh"
            warn "Open $world/run.sh and approve the startup command before continuing"

            touch $world/run.sh
            echo -e $(echo_default_run_sh) >>$world/run.sh
        fi
    fi
    ;;
*)
    error "Invalid operation"
    usage
    inputs
    exit 1
    ;;
esac
