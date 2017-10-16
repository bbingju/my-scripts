#!/bin/bash

PROGRAM_NAME="global"
VERSION="6.5.7"
SRC_FILE="${PROGRAM_NAME}-${VERSION}.tar.gz"
SRC_URL="ftp://ftp.gnu.org/pub/gnu/global/${SRC_FILE}"
CONFIGURE_OPTIONS=" \
"
JNUM="2"

function do_checkenv {
    sudo apt-get install -y build-essential
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
    sudo make install
}

set -e

do_checkenv
do_fetch
cd "${PROGRAM_NAME}-${VERSION}"
do_configure
do_build
do_install
