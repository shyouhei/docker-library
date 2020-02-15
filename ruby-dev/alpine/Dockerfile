FROM alpine:latest
MAINTAINER shyouhei@ruby-lang.org

RUN apk add --no-cache \
    autoconf \
    bison \
    gcc \
    gdbm-dev \
    git \
    glib-dev \
    gmp-dev \
    libc-dev \
    libc6-compat \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    make \
    ncurses-dev \
    openssl \
    openssl-dev \
    procps \
    readline-dev \
    ruby \
    sudo \
    tzdata \
    yaml-dev \
    zlib-dev \
 && useradd -m -u 10347 -G sudo

USER shyouhei
WORKDIR /home/shyouhei
