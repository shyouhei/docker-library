#! /bin/bash

set -x

root=/home/shyouhei/data/machines/discourse-bench

enter() {
    sudo systemd-nspawn \
         --quiet \
         --directory="$root" \
	 --setenv=DEBIAN_FRONTEND=noninteractive \
         "$@"
}

if [ ! -d $root ]; then

    set -e

    aptopts="-yy --no-install-recommends --no-install-suggests --no-upgrade"
    arch=amd64
    variant=minbase
    version=bionic
    #apt_cacher="http://172.17.0.1:3142"
    apt_cacher="http:/"

    sudo apt install systemd-container debootstrap

    sudo mkdir -p "$root"

    sudo debootstrap \
         --arch="$arch" \
         --variant="$variant" \
         "$version" "$root" \
         "$apt_cacher/jp.archive.ubuntu.com/ubuntu"

    enter -a passwd -d root
    enter -a useradd -m -u 10347 -G sudo -s /bin/bash shyouhei
    enter -a passwd -d shyouhei

    sudo mv $root/etc/apt/sources.list $root/etc/apt/sources.list.save
    sudo cp 99sources.list $root/etc/apt/sources.list.d
    sudo cp 99apt.conf $root/etc/apt/apt.conf.d
    sudo cp 99dpkg.cfg $root/etc/dpkg/dpkg.cfg.d/
    enter -a sed -i "s/arch=amd64/arch=${arch}/" \
          /etc/apt/sources.list.d/99sources.list
    enter -a sed -i "s,http://,${apt_cacher}/," \
          /etc/apt/sources.list.d/99sources.list

    enter -a apt update
    enter -a apt build-dep $aptopts ruby2.5
    enter -a apt install $aptopts postgresql \
          dbus systemd redis-server gcc-8 g++-8 libpq-dev libjemalloc-dev valgrind \
          gawk curl pngcrush git ruby ruby-dev rubygems ruby-bundler rbenv sudo \
	  curl wget apache2-utils optipng jhead gifsicle npm pngcrush brotli \
	  linux-tools-generic
    enter -a npm install -g svgo

    enter -a sed -i 's/^supervised no/supervised systemd/' /etc/redis/redis.conf
    enter -a systemctl enable systemd-networkd
    enter -a systemctl enable systemd-resolved

    enter -a mkdir -p /var/discourse
    enter -a chown -R shyouhei:shyouhei /var/discourse
    cp entrypoint.sh $root/var/discourse
fi

enter -a apt update
enter -a apt -yy upgrade
enter --boot \
      --overlay='/home/shyouhei::/home/shyouhei' \
      --system-call-filter='perf_event_open'
