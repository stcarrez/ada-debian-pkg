#!/bin/sh
# build.sh 
PKG_ROOT_DIR=`dirname $0`
PKG_ROOT_DIR=`realpath $PKG_ROOT_DIR`
PKG_ROOT_DIR=`dirname $PKG_ROOT_DIR`
PKG_FILE=$1
PKG_FILENAME=`basename $1`
PKG_DIR=`basename $PKG_FILE .tar.gz`
PKG_NAME=`echo $PKG_DIR | sed -e 's/-[0-9]*\.[0-9]*$//' -e 's/-[0-9]*\.[0-9]*\.[0-9b]*$//'`
PKG_DEBIAN_DIR=$PKG_ROOT_DIR/$PKG_NAME/debian
if test ! -d $PKG_DEBIAN_DIR; then
   echo "Debian package files:"
   echo "   Archive: $1"
   echo "   Name:    $PKG_NAME"
   echo "   Debian:  $PKG_DEBIAN_DIR"
   exit 1
fi

echo $PKG_NAME
echo $PKG_ROOT_DIR
echo $PKG_DEBIAN_DIR
# exit 0

mkdir -p build
cp $PKG_FILE build/
if test $? -ne 0; then
   echo "Cannot copy the archive file"
   exit 1
fi
cd build
if test $? -ne 0; then
   echo "Cannot set directory to build"
   exit 1
fi

rm -rf $PKG_FILENAME
tar xf $PKG_FILE
rm -rf $PKG_DIR/debian
cp -rp $PKG_DEBIAN_DIR $PKG_DIR/debian
cd $PKG_DIR
debuild -i -us -uc -b --lintian-opts --profile debian

