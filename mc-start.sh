#!/bin/bash

#region FLAG DEFINITIONS
## d    debug mode; echos inputs; will not start server
## g    y|u use gui?
## h    help
## s    how much memory Java will initially allocate for heap space (default 1024M)
## v    echo script version
## w    minecraft world / directory
## x    maximum heap space that can be allocated (default 1024M)
#endregion

#region CONSTANTS
VERSION="0.1.0"

XMX="1024M"
XMS="1024M"
DEBUG=false
do_gui="n"
#endregion CONSTANTS

#region HELP AND USAGE FUNCTIONS
echo_help() {
    echo -e "\t${1}\t${2}"
}

usage() {
    echo_help "Usage:" "$0 -w <string>"
    echo_help "Help:" "$0 -h"
}

help() {
    echo_help "-d" "Debug mode - will not start minecraft server"
    echo_help "-g" "Set GUI mode <y|n> (default n)"
    echo_help "-h" "Help menu"
    echo_help "-s" "XMS - minimum memory value (default 1024M)"
    echo_help "-v" "Script version"
    echo_help "-w" "World directory name"
    echo_help "-x" "XMX - maximum memory value (default 1024M)"
}
#endregion HELP AND USAGE FUNCTIONS

#region CAPTURE FLAGS
while getopts w:g:x:s:hdv flag; do
    case "${flag}" in
    v)
        echo $VERSION 
        exit 0
        ;;
    w) world=${OPTARG} ;;
    g) do_gui=${OPTARG} ;;
    h)
        help
        exit 0
        ;;
    x) XMX=${OPTARG} ;;
    s) XMS=${OPTARG} ;;
    d) DEBUG=true ;;
    *)
        usage
        exit 1
        ;;
    esac
done
#endregion CAPTURE FLAGS

#region ENSURE VALID ENTRIES FOR CERTAIN FLAGS
if [[ -z $world || -z $do_gui ]]; then
    usage
    exit 1
fi

gui="nogui"
if [[ $do_gui = "y" ]]; then
    gui=""
fi
#endregion ENSURE VALID ENTRIES FOR FLAGS

if [[ $DEBUG = true ]]; then
    echo "world  ${world}"
    echo "gui      ${gui}"
    echo "XMX      ${XMX}"
    echo "XMS      ${XMS}"
else
    # example: java -Xmx1024M -Xms1024M -jar minecraft_server.1.19.3.jar nogui
    cd ${world}
    java -Xmx${XMX} -Xms${XMS} -jar server.jar ${gui}
fi
