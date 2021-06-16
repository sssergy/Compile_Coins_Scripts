#!/bin/sh
make clean
chmod 777 -R *
PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g')
cd `pwd`/depends
make HOST=x86_64-w64-mingw32 -j 24
cd ..
./autogen.sh
mkdir db4
wget -c 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix/
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=`pwd`/db4
make -j24
cd ../../
./configure LDFLAGS="-L`pwd`/db4/lib/" CPPFLAGS="-I`pwd`/db4/include/" --prefix=`pwd`/depends/x86_64-w64-mingw32 --enable-tests=no --enable-bench=no
make -j24
strip src/*.exe
strip src/qt/*.exe
