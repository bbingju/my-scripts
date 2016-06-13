#!/bin/bash

PN="freeswitch"
VERSION="master"
SRC_URI="https://freeswitch.org/stash/scm/fs/${PN}.git"
CONFIGURE_OPTIONS=" \
"
JNUM="4"
S="${PN}.git"
APT="apt" 			# or apt-get

function do_checkenv {
    sudo ${APT} install -y build-essential autoconf libtool libtool-bin \
	 pkg-config yasm zlib1g-dev libjpeg-dev sqlite3 libsqlite3-dev \
	 libcurl4-openssl-dev libpcre3-dev libspeex-dev libspeexdsp-dev \
	 libldns-dev libedit-dev libopus-dev liblua5.1-dev libsndfile1-dev
}

function do_fetch {
    if [[ ! -d ${S} ]]; then
	git clone ${SRC_URI} ${S}
    fi
}

function do_configure {
    pushd ${S}

    # if [[ ! -f ./configure ]]; then
	./bootstrap.sh
    # fi

    ./configure $CONFIGURE_OPTIONS

    popd
}

function do_build {
    pushd ${S}

    if [[ ! -f Makefile ]]; then
	exit "Makefile is not found."
    fi

    make -j $JNUM

    popd
}

function do_install {
    pushd ${S}
    sudo make install
    popd
}

set -e

do_checkenv && do_fetch && do_configure && do_build && do_install
