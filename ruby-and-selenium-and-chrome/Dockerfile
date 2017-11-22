FROM shyouhei/ruby-and-selenium-and-chrome:base

RUN set -ex \
 && arch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && apt-get update \
 && apt-get build-dep -y --no-install-recommends ruby2.3 \
 && git clone \
      --depth 1 \
      --branch trunk \
      --single-branch \
      https://github.com/ruby/ruby \
 && cd ruby \
 && autoconf \
 && ./configure \
      -C \
      --build="$arch" \
      --prefix=/usr/local \
      --disable-install-doc \
      --enable-shared \
 && make -j "$(nproc)" all \
 && make install \
 && sudo apt-get markauto --ignore-missing ruby python \
 && sudo apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/cache/apt/archives /var/lib/apt/lists

RUN mkdir -p /usr/local/etc
ADD gemrc /usr/local/etc
RUN gem install bundler --force
