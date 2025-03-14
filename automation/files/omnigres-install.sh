#!/bin/bash

# We need to add epel-release to have netcat available
dnf -y install epel-release
dnf makecache

# Adds gcc-toolset-14 since Rocky 9 ships with GCC 11 and we require at least 12
dnf -y install git cmake gcc g++ cpan openssl-devel openssl-devel python-devel openssl bison flex readline-devel zlib-devel netcat gcc-toolset-14 python3-build postgresql17-plpython3

# Get our sources and compile using gcc-toolset-14
# Also add CMAKE_BUILD_TYPE=Release for better performance in production
git clone https://github.com/omnigres/omnigres.git
cd omnigres
git checkout af0b1102b94d7dc8feee7ee9d937dccd2664e096

scl enable gcc-toolset-14 "cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DOPENSSL_CONFIGURED=1 -DCMAKE_BUILD_PARALLEL_LEVEL=4"
/home/rocky/omnigres/build/venv/bin/python3.9 -m pip install build
scl enable gcc-toolset-14 "cmake --build build --parallel"
cmake --build build --parallel --target install_extensions
cp -R .pg/Linux-Release/17.4/build /usr/omnigres-17
sed -i 's/bin_dir: .*/bin_dir: \/usr\/omnigres-17\/bin/' /etc/patroni/patroni.yml
systemctl restart patroni

cd -
