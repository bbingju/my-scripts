#!/bin/bash

VERSION="25.1"
SRC_URL=http://ftp.gnu.org/gnu/emacs/emacs-"${VERSION}".tar.xz
CONFIGURE_OPTIONS="--without-toolkit-scroll-bars \
"
JNUM="4"

function do_checkenv {
    sudo apt-get -y build-dep emacs24
    sudo apt-get install -y libncurses5-dev
}

function do_fetch {
    if [[ ! -d emacs-"$VERSION" ]]; then
	wget $SRC_URL
	tar xvf emacs-"$VERSION".tar.xz
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
    sudo make install
}

set -e

do_checkenv
do_fetch
cd emacs-"${VERSION}"
do_configure
do_build
do_install
