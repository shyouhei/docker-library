#! /bin/sh
# This is almost a straight translation of docker-compose.yml 
exec sudo docker run \
     --rm \
     -it \
     --init \
     -e DISPLAY \
     --mount \
       type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
     --mount \
       type=bind,source=/home/shyouhei,target=/home/shyouhei \
     shyouhei/dev-base
