FROM ubuntu:bionic
MAINTAINER shyouhei@ruby-lang.org

ADD 01no-cache        /etc/apt/apt.conf.d/
ADD 02autopilot       /etc/apt/apt.conf.d/
ADD 03force-unsafe-io /etc/dpkg/dpkg.cfg.d/
ADD 04proxy           /etc/apt/apt.conf.d/
RUN apt-get update && \
    apt-get install -y wget gnupg2 ca-certificates && \
    rm -rf /var/lib/apt/lists/*
ADD 98gcc.list        /etc/apt/sources.list.d/
ADD 99llvm.list       /etc/apt/sources.list.d/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN sed -i 's/^# deb/deb/' /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get install -y \
        gcc     gcc-multilib \
        gcc-4.8 gcc-4.8-multilib \
        gcc-5   gcc-5-multilib \
        gcc-6   gcc-6-multilib \
        gcc-7   gcc-7-multilib \
        gcc-8   gcc-8-multilib \
        clang-3.9 clang-4.0 clang-5.0 clang-6.0 clang-7 clang-8 \
        build-essential git parallel ruby \
        libffi-dev libffi-dev:i386 libffi6:i386 \
        libgdbm-dev libgdbm-dev:i386 libgdbm5:i386 \
        libgmp-dev \
        libjemalloc-dev \
        libncurses5-dev libncurses5-dev:i386 libncurses5:i386 \
        libncursesw5-dev libncursesw5-dev:i386 \
        libreadline6-dev libreadline6-dev:i386 libreadline7:i386 \
        libssl-dev libssl-dev:i386 libssl1.0.0:i386 \
        libyaml-dev \
        linux-libc-dev:i386 \
        openssl \
        valgrind \ 
        zlib1g-dev zlib1g-dev:i386 zlib1g:i386 && \
    apt-get build-dep -y ruby2.5 ruby2.5:i386 && \
    apt-get upgrade -y && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /src /build /target
RUN git clone https://git.ruby-lang.org/ruby.git /src/trunk
RUN parallel --line-buffer -j1 -- \
    git -C /src/trunk worktree add /src/{} {} ::: \
      ruby_2_6 ruby_2_5 ruby_2_4 ruby_2_3 ruby_2_2 ruby_2_1 ruby_2_0_0 ruby_1_9_3
RUN parallel --line-buffer -j$(nproc) -- \
    cd {} '&&' autoconf ::: /src/*/
RUN parallel --line-buffer -j$(nproc) -- \
    mkdir -p /build/ruby@{2}/{1/}@git '&&' \
    cd /build/ruby@{2}/{1/}@git '&&' \
    test -f config.status '||' \
    {1}/configure \
      --cache-file=../config.cache@{1/} \
      --enable-debug-env \
      --disable-install-doc \
      --without-jemalloc \
      --without-valgrind \
      --prefix=/target/{1/}@git \
      --with-gcc={2} \
      optflags="'-O3 -march=native'" ::: \
      `bash -c 'ls -d1 /src/* | sort -r'` ::: \
      gcc-8 gcc-7 gcc-6 gcc-5 gcc-4.8 \
      clang-8 clang-7 clang-6.0 clang-5.0 clang-4.0 clang-3.9
RUN parallel --line-buffer -j$(nproc) -- \
    make -sC {} miniruby ::: /build/ruby@*/*@git
RUN parallel --line-buffer -j$(nproc) -- \
    make -sC {} ::: /build/ruby@*/*@git
RUN parallel --line-buffer -j$(nproc) -- \
    make -sC {} install ::: /build/ruby@gcc-8/*@git
