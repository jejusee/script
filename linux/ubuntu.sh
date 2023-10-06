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
    # 4G 스왑파일 생성 후 권한 수정
    sudo fallocate -l 4G /swapfile
    # 스왑파일 권한 수정
    sudo chmod 600 /swapfile
    # 해당파일이 스왑 공간으로 사용될 것임을 명시 및 메모리 활성화
    sudo mkswap /swapfile
    # 스왑파일 메모리로 활성화
    sudo swapon /swapfile
    # 재부팅시 자동활성화 되도록 /etc/fstab 에 명령 추가
    echo -e "/swapfile	none	swap	sw	0 0" >> /etc/fstab
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