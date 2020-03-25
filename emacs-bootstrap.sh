#!/bin/bash

VERSION="26.3"
FILENAME="emacs-${VERSION}.tar.xz"
SRC_URI=http://mirror.kakao.com/gnu/emacs/"${FILENAME}"
JNUM="4"

#--without-toolkit-scroll-bars
USER_CONFIGURE_OPTIONS="
	--prefix=${HOME}/.local \
"

WITHOUT_GUI_CONFIGURE_OPTIONS=('--without-x
				--without-xpm
				--without-jpeg
				--without-tiff
				--without-gif
				--without-png' )

DEP_PACKAGES=" \
pkg-config \
libgnutls28-dev \
libncurses5-dev \
"
GUI_CONFIGURE_OPTIONS=('--with-x-toolkit=gtk3')
GUI_DEP_PACKAGES=('libgtk-3-dev \
libmagickcore-dev \
libxpm-dev \
libgif-dev'
)

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

    if [ "$IS_USER" = "YES" ]; then
	CONFIGURE_OPTIONS+=$USER_CONFIGURE_OPTIONS
    fi

    # check options & dependencies for GUI
    if [ "$USE_GUI" = "YES" ]; then
	CONFIGURE_OPTIONS+=$GUI_CONFIGURE_OPTIONS
	DEP_PACKAGES+=$GUI_DEP_PACKAGES
    else
	CONFIGURE_OPTIONS+=$WITHOUT_GUI_CONFIGURE_OPTIONS
    fi

    autoreconf -fi -I m4
    ./autogen.sh
    ./configure $CONFIGURE_OPTIONS
}

function do_build {
    if [[ ! -f Makefile ]]; then
	exit "Makefile is not found."
    fi

    make -j $JNUM
}

function do_install {
    if [ "$IS_USER" = "YES" ]; then
	make install
    else
	sudo make install
    fi
}

set -e

USE_GUI=NO			# default
IS_USER=NO			# default

# Parse command-line arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
	-g|--with-gui)
	USE_GUI=YES
	shift # past argument
#	shift # past value
	;;
	-u|--user)
	    IS_USER=YES
	    shift
	;;
	*)
	POSITIONAL+=("$1")
	shift
	;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi

do_checkenv
do_fetch
pushd emacs-"${VERSION}"
do_configure && do_build && do_install
popd
