# https://bugs.ruby-lang.org/issues/13524
FROM ruby:2.4-alpine

MAINTAINER shyouhei@ruby-lang.org

WORKDIR /tmp

RUN set -ex && \
 apk update && \
 apk add openssl make autoconf bison coreutils gcc ruby libc-dev linux-headers

RUN set -ex && \
 wget https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2 && \
 tar xf jemalloc-4.5.0.tar.bz2 && \
 cd jemalloc-4.5.0 && \
 ./configure && \
 make -j4 install_bin install_include install_lib && \
 cd - && \
 rm -r jemalloc*

RUN set -ex && \
 wget https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.1.tar.gz && \
 tar xf ruby-2.4.1.tar.gz && \
 cd ruby-2.4.1 && \
 ./configure --with-jemalloc --enable-debug-env optflags=-O0 && \
 make -j4 miniruby

# Following is for inspection
# Run it with `docker run -it`
RUN apk add gdb
ADD segv.c /tmp/segv.c
RUN gcc -ljemalloc segv.c && ./a.out; true
CMD gdb a.out core
