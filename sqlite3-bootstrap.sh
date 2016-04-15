#!/bin/bash

PN="sqlite"
PV="3120100"
SRC_FILE="${PN}-autoconf-${PV}.tar.gz"
SRC_URL="https://www.sqlite.org/2016/${SRC_FILE}"
CONFIGURE_OPTIONS=" \
"
JNUM=2

# function do_checkenv {
# }

function do_clean {
    rm -rf "${PN}-autoconf-${PV}" ;
    rm -f $SRC_FILE ;
}

function do_fetch {
    if [[ ! -f $SRC_FILE ]]; then
	wget $SRC_URL
	tar xf $SRC_FILE
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

# do_checkenv

do_clean && do_fetch 
pushd "${PN}-autoconf-${PV}"
do_configure && do_build && do_install
popd
