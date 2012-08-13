#!/bin/bash
#Configure this, and also ensure you have the dev/build_data/osx.patch ready.
SRC="src"
NAME="AB"
VERSION=0.8.0

GIT=`git log --pretty=format:'%h' -n 1`
GIT_COUNT=`git log --pretty=format:'' | wc -l`

echo "git,git_count = '${GIT}','${GIT_COUNT}'" > $SRC/git.lua

# cleanup!
./clean.sh

# *.love
cd $SRC
zip -r ../${NAME}_${GIT}.love *
cd ..

# Temp Space
mkdir tmp

# Linux 32 bit
cp dev/build_data/love_i686/ tmp/ -r
cp dev/build_data/run.sh tmp/
cp ${NAME}_${GIT}.love tmp/
cd tmp
tar czvf ../${NAME}_linux-i686[$GIT].tar.gz *
cd ..
rm tmp/* -rf #tmp cleanup

# Linux 64 bit
cp dev/build_data/love_x86_64/ tmp/ -r
cp dev/build_data/run.sh tmp/
cp ${NAME}_${GIT}.love tmp/
cd tmp
tar czvf ../${NAME}_linux-x86_64[$GIT].tar.gz *
cd ..
rm tmp/* -rf #tmp cleanup

# Windows 32 bit
cat dev/build_data/love-$VERSION\-win-x86/love.exe ${NAME}_${GIT}.love > tmp/${NAME}_${GIT}.exe
cp dev/build_data/love-$VERSION\-win-x86/*.dll tmp/
cd tmp
zip -r ../${NAME}_win-x86[$GIT].zip *
cd ..
rm tmp/* -rf #tmp cleanup

# Windows 64 bit
cat dev/build_data/love-$VERSION\-win-x64/love.exe ${NAME}_${GIT}.love > tmp/${NAME}_${GIT}.exe
cp dev/build_data/love-$VERSION\-win-x64/*.dll tmp/
cd tmp
zip -r ../${NAME}_win-x64[$GIT].zip *
cd ..
rm tmp/* -rf #tmp cleanup

# OS X
cp dev/build_data/love.app tmp/${NAME}_${GIT}.app -Rv
cp ${NAME}_${GIT}.love tmp/${NAME}_${GIT}.app/Contents/Resources/
patch tmp/${NAME}_${GIT}.app/Contents/Info.plist -i dev/build_data/osx.patch
cd tmp
zip -r ../${NAME}_macosx[$GIT].zip ${NAME}_${GIT}.app
cd ..
rm tmp/* -rf #tmp cleanup

# Cleanup
rm tmp -rf
