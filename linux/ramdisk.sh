#!/bin/bash

script_name=$(basename "$0")    # 현재 스크립트 이름
ramdisk_path="/ramdisk"         # 램디스크 기본 경로

function show_usage() {
    echo "Usage: $script_name <command> [options]"
    echo "Commands:"
    echo "  install [<path>] -s|--size <size>   Install RAM disk with specified size and optional path (default: $ramdisk_path)"
    echo "  uninstall [<path>]                  Uninstall RAM disk with optional path (default: $ramdisk_path)"
    echo "Examples:"
    echo "  ./$script_name install \"$ramdisk_path\" -s=8G"
    echo "  ./$script_name uninstall \"$ramdisk_path\""
}

function create_ramdisk() {
    local path=$1
    local size=$2

    # 경로가 존재하지 않으면 물어봅니다.
    if [ ! -d "$path" ]; then
        read -p "The path $path does not exist. Would you like to create it? (y/n): " response
        if [ "$response" != "y" ]; then
            echo "Installation aborted."
            exit 1
        fi
        sudo mkdir -p $path
    elif mountpoint -q $path; then
        read -p "A RAM disk is already mounted at $path. Do you want to reinstall it? (y/n): " response
        if [ "$response" != "y" ]; then
            echo "Installation aborted."
            exit 1
        fi
        sudo umount $path
    fi

    sudo mount -t tmpfs -o size=$size tmpfs $path
    
    # /etc/fstab에 등록
    sudo sed -i "\~$path~d" /etc/fstab
    echo "tmpfs $path tmpfs size=$size 0 0" | sudo tee -a /etc/fstab > /dev/null

    echo "RAM disk successfully installed and set to mount on startup."
}

function remove_ramdisk() {
    local path=$1

    # 경로가 존재하지 않으면 물어봅니다.
    if [ ! -d "$path" ]; then
        echo "The path $path does not exist. No action taken."
        exit 1
    elif ! mountpoint -q $path; then
        echo "There is no RAM disk mounted at $path. No action taken."
        exit 1
    fi

    read -p "Are you sure you want to uninstall the RAM disk at $path? (y/n): " response
    if [ "$response" != "y" ]; then
        echo "Uninstallation aborted."
        exit 1
    fi

    sudo umount $path
    sudo rm -rf $path
    
    # /etc/fstab에서 삭제
    sudo sed -i "\~$path~d" /etc/fstab

    echo "RAM disk successfully uninstalled and removed from startup."
}

if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

command=$1
shift

case $command in
    install)
        size=""

        if [ "$1" != "" ] && [[ "$1" != -* ]]; then
            ramdisk_path=$1
            shift
        fi

        while [ "$1" != "" ]; do
            case $1 in
                -s=*|--size=* )         size="${1#*=}"
                                        ;;
                -s|--size )             shift
                                        size=$1
                                        ;;
                * )                     show_usage
                                        exit 1
            esac
            shift
        done

        if [ -z "$size" ]; then
            echo "Error: Size is required for installation."
            show_usage
            exit 1
        fi

        create_ramdisk $ramdisk_path $size
        ;;
    uninstall)

        if [ "$1" != "" ] && [[ "$1" != -* ]]; then
            ramdisk_path=$1
        fi

        remove_ramdisk $ramdisk_path
        ;;
    * ) show_usage
        exit 1
esac
