#! /bin/sh
# This is almost a straight translation of docker-compose.yml 
exec sudo docker run \
     --rm \
     -ip6 \
     -it \
     --init \
     -e DISPLAY \
     -e TZ \
     --mount \
       type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
     --mount \
       type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
     --mount \
       type=bind,source=/etc/timezone,target=/etc/timezone,readonly \
     --mount \
       type=bind,source=/home/shyouhei,target=/home/shyouhei \
     --security-opt \
       seccomp=unconfined \
     --cap-add=SYS_PTRACE \
     shyouhei/dev-tmux
