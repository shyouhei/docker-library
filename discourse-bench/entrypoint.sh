#! /bin/bash

set -e

# clone the repo if absent
if [ ! -d /var/discourse/discourse ]; then
    sudo -u postgres psql -v ON_ERROR_STOP=1 <<-EOF
CREATE USER shyouhei WITH CREATEDB SUPERUSER;
CREATE DATABASE discourse_profile;
GRANT ALL PRIVILEGES ON DATABASE discourse_profile TO shyouhei;
CREATE EXTENSION hstore;
EOF

    git clone --depth=1 \
	https://github.com/discourse/discourse.git \
	/var/discourse/discourse

    # facter needs installed, otherwise gem install happens during bench.rb
    cat <<EOF >> /var/discourse/discourse/Gemfile 
gem "facter"
gem "CFPropertyList"
gem "fileutils"
gem "date"
gem "gabbler"
EOF
    # erase BUNDLED_WITH
    head -n -2 Gemfile.lock > tmp.lock
    rm Gemfile.lock
    mv tmp.lock Gemfile.lock
fi

# global setup
source ~/.bashrc 
eval "$(rbenv init - bash)"
cd /var/discourse/discourse
rbenv local $DISCOURSE_RBENV
set -x

# run the bench
bundle install -j$(nproc) --path=vendor/bundle
RAILS_ENV=profile bundle exec ruby script/bench.rb
