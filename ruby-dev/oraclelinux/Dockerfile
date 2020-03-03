FROM oraclelinux:8
MAINTAINER shyouhei@ruby-lang.org

ADD assets /root/assets
WORKDIR /root/assets

# see https://docs.oracle.com/cd/E77782_01/html/E77783/gnzpf.html
RUN yum install -y \
    glibc \
    glibc.i686 \
    glibc-devel \
    glibc-devel.i686 \
    elfutils-libelf-devel \
    elfutils-libelf-devel.i686 \
    zlib \
    zlib.i686 \
    libstdc++ \
    libstdc++.i686 \
    libgcc \
    libgcc.i686 \
    openssl
#    openssl.i686

# missing dependencies of ODS
RUN yum install -y \
    binutils \
    bzip2 \
    libnsl \
    tar

# ruby dependency
RUN yum install -y \
    autoconf \
    bison \
    gdbm-devel \
    git \
    libffi-devel \
    libxml2-devel \
    libxslt-devel \
    make \
    ncurses-devel \
    openssl-devel \
    readline-devel \
    ruby \
    rubygems \
    tzdata \
    zlib-devel

RUN mkdir -p /opt
RUN tar \
    --strip=1 \
    -C /opt \
    --exclude=developerstudio*.*/OIC \
    --exclude=developerstudio*.*/lib/netbeans \
    --exclude=developerstudio*.*/lib/devstudio \
    -xpf *.tar.bz2
