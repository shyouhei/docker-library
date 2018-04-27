# https://bugs.ruby-lang.org/issues/14716
FROM ubuntu:trusty

MAINTAINER shyouhei@ruby-lang.org

WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's/^# deb/deb/' /etc/apt/sources.list

RUN apt-get update            \
 && apt-get build-dep ruby2.0 \
 && apt-get install wget      \
 && apt-get upgrade           \
 && apt-get autoremove        \
 && apt-get clean

RUN wget -o/dev/null https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz
RUN tar xfp ruby-2.5.1.tar.gz

WORKDIR /tmp/ruby-2.5.1
RUN ./configure && make -j install-nodoc

RUN rm /dev/urandom
RUN /usr/local/bin/ruby -rsecurerandom -ve 'p SecureRandom.uuid'
