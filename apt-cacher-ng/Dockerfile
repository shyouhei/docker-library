# PREPARE: sudo mkdir /var/cache/apt-cacher-ng && sudo chmod 2755 /var/acche/apt-cacher-ng
# Run: sudo docker run --name apt-cacher-ng -d --restart=always --publish 172.17.0.1:3142:3142 -v /var/cache/apt-cacher-ng:/var/cache/apt-cacher-ng shyouhei/apt-cacher-ng:latest
#
# Client setup: echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy
FROM debian:stretch-slim
MAINTAINER shyouhei@ruby-lang.org

VOLUME ["/var/cache/apt-cacher-ng"]
#RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy
RUN sed -i s/deb.debian.org/ftp.jp.debian.org/ /etc/apt/sources.list
RUN apt update && apt upgrade -y && apt-get install -y apt-cacher-ng && apt-get autoremove -y
RUN echo 'PassThroughPattern: :443$' >> /etc/apt-cacher-ng/acng.conf
ADD ubuntu_mirrors /tmp/src
RUN cat /usr/lib/apt-cacher-ng/ubuntu_mirrors /tmp/src | sort -u > /tmp/ubuntu_mirrors && mv /tmp/ubuntu_mirrors /usr/lib/apt-cacher-ng

EXPOSE 3142
CMD chmod 777 /var/cache/apt-cacher-ng && /etc/init.d/apt-cacher-ng start && tail -f /var/log/apt-cacher-ng/*
