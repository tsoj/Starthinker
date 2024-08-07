#!/bin/bash

set -e

mkdir -p ./ext/cppfront/target/
cd ./ext/cppfront

if [ ! -d "cppfront" ]; then
    git clone --recursive https://github.com/tsoj/modern-cmake-cppfront
    cd cppfront
    git checkout 7469a30a930db54ea8ecd7c5d585f03ba2c0fd7f
    cd ..
fi

cmake -S cppfront -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./target
cmake --build build --target clean
cmake --build build --target install

