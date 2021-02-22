#!/bin/sh

SRC=../ada-awa/$1/debian
DST=$1/debian
if test ! -d $SRC; then
   echo "Directory $SRC not found"
   exit 1
fi

if test ! -d $DST; then
   echo "Directory $DST not found"
   exit 1
fi

cp $SRC/control $DST/control
cp $SRC/changelog $DST/changelog
cp $SRC/docs $DST/docs
cp $SRC/rules $DST/rules
cp $SRC/ada_libraries $DST/ada_libraries
cp $SRC/copyright $DST/copyright
if test -f $SRC/examples.gpr; then
  cp $SRC/examples.gpr $DST/examples.gpr
fi
if test -f $SRC/utilada.gpr; then
  cp $SRC/utilada.gpr $DST/tilada.gpr
fi
if test -f $SRC/utilada_http.gpr; then
  cp $SRC/utilada_http.gpr $DST/tilada_http.gpr
fi
for i in `find $SRC -name '*.docs'`; do
  NAME=`basename $i`
  cp $i $DST/$NAME
done
for i in `find $SRC -name '*.install'`; do
  NAME=`basename $i`
  cp $i $DST/$NAME
done
for i in `find $SRC -name '*.examples'`; do
  NAME=`basename $i`
  cp $i $DST/$NAME
done
for i in `find $SRC -name '*.doc-base*'`; do
  NAME=`basename $i`
  cp $i $DST/$NAME
done

