#!/bin/bash

PROGRAM_NAME="global"
VERSION="6.6.3"
SRC_FILE="${PROGRAM_NAME}-${VERSION}.tar.gz"
SRC_URL="ftp://ftp.gnu.org/pub/gnu/global/${SRC_FILE}"
CONFIGURE_OPTIONS=" \
--prefix=${HOME}/.local \
--with-exuberant-ctags=/usr/bin/ctags \
"
JNUM="2"

function do_checkenv {
    sudo apt-get install -y build-essential ctags libtool-bin
}

function do_fetch {
    if [[ ! -d $SRC_FILE ]]; then
	wget $SRC_URL
	tar xvf $SRC_FILE
    fi
}

function do_configure {
    if [[ ! -f ./configure ]]; then
	exit "the configure is not found."
    fi

    ./configure $CONFIGURE_OPTIONS
}

function do_build {
    if [[ ! -f Makefile ]]; then
	exit "Makefile is not found."
    fi

    make -j $JNUM
}

function do_install {
    make install
}

set -e

# do_checkenv
do_fetch
pushd "${PROGRAM_NAME}-${VERSION}"
do_configure
do_build
do_install
popd

git clone https://github.com/yoshizow/global-pygments-plugin.git
pushd global-pygments-plugin/
sh reconf.sh
do_configure
do_build
do_install
cp sample.globalrc $HOME/.globalrc
popd
