#!/bin/sh
# build.sh 
PKG_ROOT_DIR=`dirname $0`
PKG_ROOT_DIR=`realpath $PKG_ROOT_DIR`
PKG_ROOT_DIR=`dirname $PKG_ROOT_DIR`
if test $# -ne 1; then
   echo "Usage:    debuild.sh <dir>"
   echo "Example:  debuild.sh ada-lzma"
   exit 2
fi

PKG_DIR=$1
if test ! -d $PKG_DIR; then
   echo "Directory does not exist: $PKG_DIR"
   exit 1
fi

cd $PKG_DIR

dpkg-buildpackage -rfakeroot -ui -i --sign-key=8285360D7F307A211AD113FC7D8211A1E929CEB3 -b
