#!/bin/sh
find . -name '*.substvars' | xargs rm -f
find . -name '*.log' | xargs rm -f
find . -name 'autoreconf.after' | xargs rm -f
find . -name 'autoreconf.before' | xargs rm -f
find . -name 'debhelper-build-stamp' | xargs rm -f
find . -type d -a -name '*3-dev' | xargs rm -rf
rm -rf */debian/tmp

