FROM debian:bullseye

RUN mkdir /src
RUN mkdir /build
RUN mkdir /prj
COPY a.rb /prj

RUN grep '^deb ' /etc/apt/sources.list \
  | sed 's/^deb /deb-src /' \
  | tee /etc/apt/sources.list.d/deb-src.list
RUN apt-get update
RUN apt-get build-dep -y ruby2.7
RUN apt-get install -y libjemalloc-dev libprotobuf-dev git gdb ruby2.7
RUN git clone \
      -c pack.threads=$(nproc --all) \
      --single-branch \
      --shallow-since=yesterday \
      --branch=master \
      https://github.com/ruby/ruby.git \
      /src
RUN /src/autogen.sh

WORKDIR /build
RUN /src/configure -C --disable-install-doc --enable-shared --with-jemalloc
RUN make -j$(nproc)
RUN make install
RUN apt-get purge -y --autoremove ruby2.7

WORKDIR /prj
CMD gdb -batch \
        -ex run \
	-ex bt \
        --args ruby a.rb

