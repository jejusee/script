#!/bin/bash

THIS_SCRIPT_NAME=$(basename "$0")
THIS_LOG_FILE=""
HOSTNAME=$(uname -n)
ARCHITECTURE=$(uname -m)
OSNAME=$(grep '^PRETTY_NAME=' /etc/os-release | awk -F '=' '{print $2}' | tr -d '"')

#
while :; do
    clear

    echo ""
    echo "####################################################################################################"
    echo "## $THIS_SCRIPT_NAME"
    echo "## host: $HOSTNAME, arch: $ARCHITECTURE, OS: $OSNAME"    
    echo "## time: $(timedatectl | grep 'Local time:' | awk -F 'time: ' '{print $2}')"
    echo "####################################################################################################"
    echo ""
    echo " a1) 서버시간대 변경"
    echo " a2) SWAP 세팅"
    echo " a3) ramdisk 세팅"
    echo ""
    echo " b1) docker 설치"
    echo " b2) docker-compose 설치"
    echo ""
    echo " u) OS Update"
    echo " q) 종료"
    echo ""
    echo "####################################################################################################"
    read -p "# 원하시는 기능을 입력하세요. > " SELECT_VALUE
    echo ""

    case $SELECT_VALUE in
      a1) set_timezone;;
      a2) set_swap;;
      a3) set_ramdisk;;
      b1) install_docker;;
      b2) install_docker_compose;;
      u) update_os;;
      q) break;;
    esac

    read -p "# 계속하려면 엔터키를 누르세요..." SELECT_VALUE
done

#
function update_os() {
    sudo apt update -y && sudo apt upgrade -y
}

#
function set_timezone() {
    sudo timedatectl set-timezone Asia/Seoul
    echo "$(timedatectl | grep 'Local time:' | awk -F 'time: ' '{print $2}')"
}

#
function set_swap() {
}

#
function set_ramdisk() {
}

#
function install_docker() {
    sudo apt install docker.io
    sudo chmod 666 /var/run/docker.sock
}

#
function install_docker_compose() {
    sudo apt install docker-compose
}
