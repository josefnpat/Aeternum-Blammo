#!/bin/bash
cd dev/build_data
VERSION=0.8.0

# linux 32-bit i686
#mirror love_i686.tar.gz
tar xvf love_i686.tar.gz

# linux 64-bit x86_64
#mirror love_x86_64.tar.gz
tar xvf love_x86_64.tar.gz

# windows 32 bit
wget -t 2 -c https://bitbucket.org/rude/love/downloads/love-$VERSION\-win-x86.zip
unzip love-$VERSION\-win-x86.zip

# windows 64 bit
wget -t 2 -c https://bitbucket.org/rude/love/downloads/love-$VERSION\-win-x64.zip
unzip love-$VERSION\-win-x64.zip

# os x universal
wget -t 2 -c https://bitbucket.org/rude/love/downloads/love-$VERSION\-macosx-ub.zip
unzip love-$VERSION\-macosx-ub.zip
