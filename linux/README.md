# Linux용 script
리눅스 스크립트

0. 
```
# 최신버전 다운
curl -sO "https://raw.githubusercontent.com/jejusee/script/main/linux/_common"

# 배치파일에 추가
if [ ! -f "_common" ]; then echo ""; exit; fi; source "_common";
```
  
```
# 시스템 정보 가져오기
curl -sSL https://raw.githubusercontent.com/jejusee/script/main/linux/_common | bash -s sysinfo
```

```
# 램디스크 설치 or 삭제
bash <(curl -s https://raw.githubusercontent.com/jejusee/script/main/linux/ramdisk.sh) install
bash <(curl -s https://raw.githubusercontent.com/jejusee/script/main/linux/ramdisk.sh) uninstall

bash <(curl -s https://raw.githubusercontent.com/jejusee/script/main/linux/ramdisk) setup


```
