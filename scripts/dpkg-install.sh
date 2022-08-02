#!/bin/sh
# build.sh 
PKG_REPO_DIR=/build/repo
PKG_REPO_NAME=focal
PKG_ROOT_DIR=`dirname $0`
PKG_ROOT_DIR=`realpath $PKG_ROOT_DIR`
PKG_ROOT_DIR=`dirname $PKG_ROOT_DIR`
if test $# -ne 1; then
   echo "Usage:    dpkg-install.sh <dir>"
   echo "Example:  dpkg-install.sh ada-lzma"
   exit 2
fi

PKG_DIR=$1
if test ! -d $PKG_DIR; then
   echo "Directory not found $PKG_DIR"
   exit 1
fi

if test ! -f $PKG_DIR/debian/files; then
   echo "Debian file $PKG_DIR/debian/files not found"
   exit 1
fi

DEB_FILES=""
DEB_LONG_FILES=""
DEB_NAMES=""
files=`awk '{print($1);}' $PKG_DIR/debian/files`
for file in $files; do
   case $file in
     *.deb)
       DEB_FILES="$DEB_FILES $file"
       DEB_LONG_FILES="$DEB_LONG_FILES $PKG_ROOT_DIR/$file"
       NAME=`echo $file | sed -e 's,_.*,,'`
       DEB_NAMES="$DEB_NAMES $NAME"
       ;;

     *)
       ;;
   esac
done

sudo dpkg -i $DEB_FILES

cd $PKG_REPO_DIR
reprepro -Vb . remove $PKG_REPO_NAME $DEB_NAMES

reprepro -Vb . includedeb $PKG_REPO_NAME $DEB_LONG_FILES

