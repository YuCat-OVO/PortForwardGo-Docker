#!/bin/bash

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

check_architecture() {
    case $(uname -m) in
    x86_64)
        arch="amd64"
        ;;
    i386 | i686)
        arch="386"
        ;;
    armv5* | armv6* | armv7*)
        arch="armv7"
        ;;
    aarch64)
        arch="arm64"
        ;;
    s390x)
        arch="s390x"
        ;;
    *)
        echo -e "${Font_Red}Unsupport architecture$Font_Suffix"
        exit 1
        ;;
    esac
}

download_files() {
    # arm64 download all version
    if [ -n "$1" ]; then
        local download_arch=$1
        local download_path="/tmp/RClient_${1}.tar.gz"
    else
        local download_arch=$arch
        local download_path="/tmp/RClient.tar.gz"
    fi

    local url="$mirror/PortForwardGo/${ver}/RClient_${ver}_linux_${download_arch}.tar.gz"
    if [ ! -f "$download_path" ]; then
        if command -v curl >/dev/null; then
            curl -L -o "${download_path}" "$url"
        elif command -v wget >/dev/null; then
            wget -nv -O "${download_path}" "$url"
        else
            echo "Error: Neither curl nor wget is available."
            exit 1
        fi
    fi
    if [ ! -f "${download_path}" ]; then
        echo -e "${Font_Red}${download_arch} Download failed${Font_Suffix}"
        exit 1
    fi
}

extract_files() {
    mkdir -p /app/{bin,config}
    # arm64 download all version
    if [ "$arch" == "amd64" ]; then
        for i in amd64v{1..4}; do
            if [ ! -f "/tmp/RClient_${i}" ]; then
                mkdir "/tmp/RClient_${i}"
            fi
            tar -xzf "/tmp/RClient_${i}.tar.gz" -C "/tmp/RClient_${i}"
            mv "/tmp/RClient_${i}/RClient" "/app/bin/RClient_${i}"
        done
        mv "/tmp/RClient_amd64v1/examples/RClient/config.json" "/app/config/config.json"
    else
        tar -xzf "/tmp/RClient.tar.gz" -C "/app"
        mv "/app/examples/RClient/config.json" "/app/config/config.json"
        rm -rf /app/examples
        rm -rf /app/systemd
        rm -rf /app/README.md
    fi
}

main() {
    init_color
    echo -e "${Font_SkyBlue}RClient download${Font_Suffix}"
    echo -e "${Font_SkyBlue}$(uname -m)${Font_Suffix}"
    mirror="https://pkg.zeroteam.top"
    ver=${VERSION:-"1.2.0"}
    arch=${ARCH:-"amd64"}
    while [ $# -gt 0 ]; do
        case $1 in
        --mirror)
            mirror=$2
            shift
            ;;
        --version)
            ver=$2
            shift
            ;;
        --arch)
            arch=$2
            ;;
        *)
            echo -e "${Font_Red} Unknown param: $1 ${Font_Suffix}"
            exit 1
            ;;
        esac
        shift
    done
    # check_architecture
    if [ "$arch" == "amd64" ]; then
        for i in amd64v{1..4}; do
            download_files "$i"
        done
    else
        download_files
    fi
    extract_files
    cp -a /scripts/start.sh /app/start.sh
}

main "$@"
