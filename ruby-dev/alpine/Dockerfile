FROM alpine:latest
MAINTAINER shyouhei@ruby-lang.org

ADD assets/sudo.conf /etc/
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
 && adduser -u 10347 -D shyouhei

ADD assets/99sudoers /etc/sudoers.d
USER shyouhei
WORKDIR /home/shyouhei
