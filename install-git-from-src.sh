#!/bin/bash


GIT_VERSION=2.6.1
GIT_FILE=v$GIT_VERSION.zip
GIT_URL=https://github.com/git/git/archive/$GIT_FILE

do_clean() {
    rm -rf git-$GIT_VERSION ; 
    rm -f $GIT_FILE ;
}

do_fetch() {
    wget $GIT_URL ;
    unzip $GIT_FILE ;
}

do_build() {
    cd git-$GIT_VERSION ;
    make configure ;
    ./configure --prefix=/usr ;
    make all doc ;
    sudo make install install-doc ;
}

do_clean && do_fetch && do_build
