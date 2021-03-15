# https://bugs.ruby-lang.org/issues/17723
FROM archlinux:latest

MAINTAINER shyouhei@ruby-lang.org

RUN pacman -Sy
RUN pacman -S --noconfirm --needed base-devel libffi libyaml openssl zlib git ruby
RUN git clone https://github.com/ruby/ruby.git


WORKDIR ruby
RUN autoreconf -vi
RUN ./configure
RUN make -sj$(nproc)

