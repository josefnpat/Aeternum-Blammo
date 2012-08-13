#!/bin/sh
M=`uname -m`
export LD_LIBRARY_PATH=/love_$M:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=./love_$M/
./love_$M/love *.love
