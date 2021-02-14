#!/bin/sh
PKG_ROOT_DIR=`dirname $0`
PKG_ROOT_DIR=`realpath $PKG_ROOT_DIR`
PKG_ROOT_DIR=`dirname $PKG_ROOT_DIR`
if test $# -ne 1; then
   echo "Usage:    git-sync.sh <dir>"
   echo "Example:  git-sync.sh ada-lzma"
   exit 2
fi

PKG_DIR=$1
if test ! -d $PKG_DIR; then
   echo "Directory does not exist: $PKG_DIR"
   exit 1
fi

cd $PKG_DIR
git pull
git merge remotes/origin/master
