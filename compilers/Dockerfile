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
        gcc     g++      gcc-multilib     g++-multilib \
        gcc-4.8 g++-4.8  gcc-4.8-multilib g++-4.8-multilib \
        gcc-5   g++-5    gcc-5-multilib   g++-5-multilib \
        gcc-6   g++-6    gcc-6-multilib   g++-6-multilib \
        gcc-7   g++-7    gcc-7-multilib   g++-7-multilib \
        gcc-8   g++-8    gcc-8-multilib   g++-8-multilib \
        gcc-9   g++-9    gcc-9-multilib   g++-9-multilib \
        clang-3.9  libclang-3.9-dev llvm-3.9-tools         clang-format-3.9 clang-tidy-3.9 \
        clang-4.0  libclang-4.0-dev llvm-4.0-tools lld-4.0 clang-format-4.0 clang-tidy-4.0 clang-tools-4.0 \
        clang-5.0  libclang-5.0-dev llvm-5.0-tools lld-5.0 clang-format-5.0 clang-tidy-5.0 clang-tools-5.0 \
        clang-6.0  libclang-6.0-dev llvm-6.0-tools lld-6.0 clang-format-6.0 clang-tidy-6.0 clang-tools-6.0 \
        clang-7    libclang-7-dev   llvm-7-tools   lld-7   clang-format-7   clang-tidy-7   clang-tools-7   \
        clang-8    libclang-8-dev                  lld-8   clang-format-8   clang-tidy-8   clang-tools-8   \
        clang-9    libclang-9-dev   llvm-9-tools   lld-9   clang-format-9   clang-tidy-9   clang-tools-9   \
        clang-10   libclang-10-dev  llvm-10-tools  lld-10  clang-format-10  clang-tidy-10  clang-tools-10  libc++-10-dev libc++abi-10-dev \
        clang gdb gdb-multiarch \
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
        doxygen \
        build-essential git git-man subversion parallel ruby rbenv ruby-build \
        manpages manpages-dev manpages-posix manpages-posix-dev \
        tzdata \
        libmysqlclient-dev libpq-dev libsqlite3-dev libxml2-dev libxmlsec1-dev \
 && apt-get build-dep \
        ruby2.5 ruby2.5:i386 \
 && apt-get upgrade \
 && apt-get autoremove

RUN useradd -u 10347 shyouhei
