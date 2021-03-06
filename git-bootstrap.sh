#!/bin/bash

GIT_VERSION="2.23.0"
GIT_FILE="v${GIT_VERSION}.zip"
SRC_URI="https://github.com/git/git/archive/${GIT_FILE}"
CONFIGURE_OPTIONS=" \
		    --prefix=${HOME}/.local \
"
JNUM=2

function do_checkenv {
    sudo apt-get install -y autoconf automake zlib1g-dev asciidoc \
	 libcurl4-openssl-dev gettext
}

function do_clean {
    rm -rf git-${GIT_VERSION} ;
    rm -f ${GIT_FILE} ;
}

function do_fetch {

    if [[ ! -f ${GIT_FILE} ]]; then
	wget $SRC_URI
    fi

    if command -v unzip 2> /dev/null; then
	unzip $GIT_FILE
    else
	sudo apt-get install -y unzip
	unzip $GIT_FILE
    fi
}

function do_build {
    pushd git-${GIT_VERSION}

    make configure

    if [[ ! -f ./configure ]]; then
	exit "the configure is not found."
    fi

    ./configure $CONFIGURE_OPTIONS
    make all doc -j $JNUM
    make install install-doc

    popd
}

set -e

do_checkenv
do_clean
do_fetch
do_build
