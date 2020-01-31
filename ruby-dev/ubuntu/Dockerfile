FROM ubuntu:rolling
MAINTAINER shyouhei@ruby-lang.org

ADD assets/99apt.conf /etc/apt/apt.conf.d/
ADD assets/99dpkg.cfg /etc/dpkg/dpkg.cfg.d/

RUN set -ex \
 && grep '^deb ' /etc/apt/sources.list \
  | sed 's/^deb /deb-src /' \
  | tee /etc/apt/sources.list.d/deb-src.list \
 && apt-get update \
 && apt-get build-dep ruby2.5