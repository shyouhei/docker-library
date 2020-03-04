#! /bin/sh
# sudo docker volume create dev-base
exec sudo docker run \
     --rm \
     -ip6 \
     -it \
     --init \
     -e TZ \
     --mount \
       type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
     --mount \
       type=bind,source=/etc/timezone,target=/etc/timezone,readonly \
     --mount \
       source=dev-base,target=/home/shyouhei \
     --security-opt \
       seccomp=unconfined \
     --cap-add=SYS_PTRACE \
     --cap-add=SYS_ADMIN \
     --dns=8.8.8.8 \
     --dns=8.8.4.4 \
     shyouhei/dev-base
