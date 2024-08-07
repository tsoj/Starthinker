#!/bin/bash

set -e

mkdir -p ./ext/cppfront/target/
cd ./ext/cppfront

if [ ! -d "cppfront" ]; then
    git clone --recursive https://github.com/tsoj/modern-cmake-cppfront
    cd modern-cmake-cppfront
    git checkout b75a21acc9c9b38f62d4c5aec790d6f09f4da383
    cd ..
fi

cmake -S modern-cmake-cppfront -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./target
cmake --build build --target clean
cmake --build build --target install

