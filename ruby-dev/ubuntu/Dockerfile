FROM ubuntu:rolling
MAINTAINER shyouhei@ruby-lang.org

ADD assets/99apt.conf /etc/apt/apt.conf.d/
ADD assets/99dpkg.cfg /etc/dpkg/dpkg.cfg.d/
ADD assets/sudo.conf /etc/

RUN set -ex \
 && grep '^deb ' /etc/apt/sources.list \
  | sed 's/^deb /deb-src /' \
  | tee /etc/apt/sources.list.d/deb-src.list \
 && apt-get update \
 && apt-get build-dep ruby2.7 \
 && apt-get install tzdata sudo git ruby \
 && useradd -m -u 10347 -G sudo shyouhei

RUN set -ex \
 && rm /usr/bin/man \
 && dpkg-divert --quiet --remove --rename /usr/bin/man

ADD assets/99sudoers /etc/sudoers.d
USER shyouhei
WORKDIR /home/shyouhei
