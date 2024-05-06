#!/bin/sh

init_color() {
    Font_Black="\033[30m"
    Font_Red="\033[31m"
    Font_Green="\033[32m"
    Font_Yellow="\033[33m"
    Font_Blue="\033[34m"
    Font_Purple="\033[35m"
    Font_SkyBlue="\033[36m"
    Font_White="\033[37m"
    Font_Suffix="\033[0m"
}

has_cpu_flags() {
    flags=$(grep -E '^flags' /proc/cpuinfo | head -n 1 | awk -F ':' '{print $2}')
    if [ -z "$flags" ]; then
        flags=$(grep -E '^Features' /proc/cpuinfo | head -n 1 | awk -F ':' '{print $2}')
    fi
    for flag in "$@"; do
        if ! echo "$flags" | grep -q "\\<$flag\\>"; then
            return 1
        fi
    done
}

check_amd64_version() {
    arch="amd64v1"

    ## x86-64-v2
    has_cpu_flags cx16 lahf_lm popcnt sse4_1 sse4_2 ssse3 || return 0
    arch="amd64v2"

    ## x86-64-v3
    has_cpu_flags avx avx2 bmi1 bmi2 f16c fma abm movbe xsave || return 0
    arch="amd64v3"

    ## x86-64-v4
    has_cpu_flags avx512f avx512bw avx512cd avx512dq avx512vl || return 0
    arch="amd64v4"
}

check_start() {
    CONFIG_PATH=${CONFIG_PATH:-"-config /app/config/config.json"}
    LOG_PATH=${LOG_PATH:-"-log /dev/stdin"}
    if [ "$DEBUG_FLAG" = true ]; then
        DEBUG="-debug "
    fi
    if [ "$DISABLE_UDP" = true ]; then
        UDP="-disable-udp "
    fi
    while [ $# -gt 0 ]; do
        case $1 in
        --help | -h)
            HELP="-h"
            shift
            ;;
        --api)
            API_URL="-api $2"
            shift
            ;;
        --id)
            API_ID="-id $2"
            shift
            ;;
        --secret)
            API_SECRET="-secret $2"
            shift
            ;;
        --config)
            CONFIG_PATH="-config $2"
            shift
            ;;
        --log)
            LOG_PATH="-log $2"
            shift
            ;;
        --debug)
            DEBUG="-debug "
            shift
            ;;
        --disable-udp)
            UDP="-disable-udp "
            ;;
        *)
            printf "%s Unknown param: $1 %s" "${Font_Red}" "${Font_Suffix}"
            ;;
        esac
        shift
    done
}

main() {
    init_color
    if [ "$(uname -m)" = "x86_64" ]; then
        check_amd64_version
        if [ ! -f /app/RClient ]; then
            ln -s "/app/bin/RClient_${arch}" /app/RClient
        fi
    fi
    check_start "$@"
    command="/app/RClient $HELP $API_URL $API_ID $API_SECRET $CONFIG_PATH $DEBUG$UDP$LOG_PATH"
}

main "$@"
$command
