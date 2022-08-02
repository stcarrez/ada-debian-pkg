#!/bin/sh
L="ada-lzma ada-util ada-el ada-keystore ada-security ada-wiki ada-servlet ada-ado ada-asf openapi-ada dynamo"
for i in $L; do
  echo "======== $i ========="
  ./scripts/build.sh $i
  echo "======== $i ========="
done

sudo apt-get remove -f libawa3-dev

./scripts/build.sh awa

