# Linux용 script
리눅스 스크립트

1. 시스템 정보 가져오기
  
```
# print
curl -sSL https://raw.githubusercontent.com/jejusee/script/main/linux/sysinfo | bash -s print

# source
if [ ! -f ./sysinfo ]; then curl -sO https://raw.githubusercontent.com/jejusee/script/main/linux/sysinfo; fi; source sysinfo;
```
