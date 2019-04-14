#!/bin/bash

VERSION="26.2"
FILENAME="emacs-${VERSION}.tar.xz"
SRC_URI=http://ftpmirror.gnu.org/emacs/"${FILENAME}"
JNUM="4"

#--without-toolkit-scroll-bars
CONFIGURE_OPTIONS="
	--prefix=${HOME}/.local \
	--with-x-toolkit=gtk3 \
"

DEP_PACKAGES=" \
libgtk-3-dev \
libmagickcore-dev \
libxpm-dev \
libgif-dev \
libgnutls28-dev \
libncurses5-dev \
"

function do_checkenv {
    sudo apt-get install -y build-essential $DEP_PACKAGES
}

function do_fetch {
    if [[ ! -f $FILENAME ]]; then
	wget $SRC_URI
    fi

    tar xvf $FILENAME
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

do_checkenv
do_fetch
pushd emacs-"${VERSION}"
do_configure
do_build
do_install
popd
