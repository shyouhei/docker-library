# Run: ./run.sh
# Hint: don't try to docker-compose up, that should break the terminal.

FROM golang:latest as ghq
RUN go get github.com/motemen/ghq

FROM ubuntu:bionic
MAINTAINER shyouhei@ruby-lang.org

ADD assets/99apt.conf /etc/apt/apt.conf.d/
ADD assets/99dpkg.cfg /etc/dpkg/dpkg.cfg.d/

RUN apt-get update && apt-get install wget gnupg2 ca-certificates

ADD assets/98gcc.list  /etc/apt/sources.list.d/
ADD assets/99llvm.list /etc/apt/sources.list.d/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-key adv \
      --keyserver hkp://keyserver.ubuntu.com:80 \
      --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key \
  | apt-key add -

RUN grep '^deb ' /etc/apt/sources.list \
  | sed 's/^deb /deb-src /' \
  | tee /etc/apt/sources.list.d/deb-src.list

RUN dpkg --add-architecture i386

RUN apt-get update \
 && apt-get install \
        gcc     gcc-multilib \
        gcc-4.8 gcc-4.8-multilib \
        gcc-5   gcc-5-multilib \
        gcc-6   gcc-6-multilib \
        gcc-7   gcc-7-multilib \
        gcc-8   gcc-8-multilib \
        clang-3.9 clang-4.0 clang-5.0 clang-6.0 clang-7 clang-8 clang-9 \
        lldb gdb gdb-multiarch \
        libffi-dev libffi-dev:i386 libffi6:i386 \
        libgdbm-dev libgdbm-dev:i386 libgdbm5:i386 \
        libgmp-dev \
        libjemalloc-dev \
        libncurses5-dev libncurses5-dev:i386 libncurses5:i386 \
        libncursesw5-dev libncursesw5-dev:i386 \
        libreadline6-dev libreadline6-dev:i386 libreadline7:i386 \
        libssl-dev libssl-dev:i386 libssl1.1:i386 \
        libyaml-dev \
        linux-libc-dev:i386 \
        zlib1g-dev zlib1g-dev:i386 zlib1g:i386 \
        openssl \
        valgrind \ 
        build-essential git git-man subversion parallel ruby rbenv ruby-build \
        manpages manpages-dev manpages-posix manpages-posix-dev \
        tzdata \
        libmysqlclient-dev libpq-dev libsqlite3-dev libxml2-dev libxmlsec1-dev \
 && apt-get build-dep \
        ruby2.5 ruby2.5:i386 \
 && apt-get upgrade \
 && apt-get autoremove

# tcc chicken-bin ghc rustc ocaml w3m

COPY --from=ghq /go/bin/ghq /usr/local/bin/ghq

RUN useradd -u 10347 shyouhei
