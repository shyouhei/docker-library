# Run: ./run.sh
# Hint: don't try to docker-compose up, that should break the terminal.

FROM golang:latest as ghq
RUN go get github.com/motemen/ghq

FROM shyouhei/c-compilers:latest
MAINTAINER shyouhei@ruby-lang.org

RUN apt-get update \
 && apt-get install \
        xz-utils pixz pigz nkf less lv lzop pcregrep jq sl tree \
        openssh-client gist zsh vim tmux xsel sudo \
        build-essential git git-man subversion parallel ruby rbenv ruby-build \
        manpages manpages-dev manpages-posix manpages-posix-dev \
        tzdata \
        libmysqlclient-dev libpq-dev libsqlite3-dev libxml2-dev libxmlsec1-dev \
 && apt-get upgrade \
 && apt-get autoremove

# tcc chicken-bin ghc rustc ocaml w3m

COPY --from=ghq /go/bin/ghq /usr/local/bin/ghq

RUN useradd -u 10347 -G sudo shyouhei
RUN passwd -d shyouhei
USER shyouhei
WORKDIR /home/shyouhei
