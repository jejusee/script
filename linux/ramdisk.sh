#!/bin/bash

# 설치 모드일 때
if [ "$1" == "install" ]; then

    # 기본값 설정
    path="/ramdisk"
    size="8G"

    # 사용자로부터 경로와 용량 입력 받기
    read -p "Ramdisk를 설치할 경로를 입력하세요 (기본값: $path): " custom_path
    path=${custom_path:-$path}

    # 경로가 존재하지 않을 경우
    if [ ! -d "$path" ]; then
        read -p "\"$path\" 경로가 존재하지 않습니다. 새로 만드시겠습니까? (y/n): " response
        if [ "$response" != "y" ]; then
            echo "설치를 취소하였습니다."
            exit 1
        fi
        sudo mkdir -p $path
    # 경로가 이미 마운트되어 있을 경우
    elif mountpoint -q $path; then
        read -p "\"$path\" 에 이미 램디스크가 마운트 되어 있습니다. 다시 설치하시겠습니까? (y/n): " response
        if [ "$response" != "y" ]; then
            echo "설치를 취소하였습니다."
            exit 1
        fi
        sudo umount $path
    fi
    
    read -p "Ramdisk의 용량을 입력하세요 (예: 100M, 1G, 기본값: $size): " custom_size
    size=${custom_size:-$size}

    # Ramdisk 생성
    sudo mount -t tmpfs -o size=$size tmpfs $path
    echo "램디스크 설치하였습니다."

    # 생성된 Ramdisk 정보 출력
    df -h $path
    
    # /etc/fstab에 등록
    sudo sed -i "\~$path~d" /etc/fstab
    echo "tmpfs $path tmpfs size=$size 0 0" | sudo tee -a /etc/fstab > /dev/null
    echo "시작시 램디스크를 사용합니다."

# 삭제 모드일 때
elif [ "$1" == "uninstall" ]; then

    # 현재 설치된 Ramdisk 목록 출력
    echo "현재 설치된 Ramdisk 목록:"
    df -h | grep tmpfs

    # 사용자로부터 삭제할 Ramdisk 선택 받기
    read -p "삭제할 Ramdisk의 경로를 입력하세요: " path

    # Ramdisk 삭제
    sudo umount $path
    sudo rm -rf $path
    echo "Ramdisk가 삭제되었습니다."

    # /etc/fstab에서 삭제
    sudo sed -i "\~$path~d" /etc/fstab
    echo "시작시 램디스크를 사용하지 않습니다."
else    
    script_name=$(basename "$0")    # 현재 스크립트 이름
    echo "사용법: ./$script_name [install | uninstall]"
fi
