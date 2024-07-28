#!/bin/bash

set -e

mkdir -p ./cppfront/target/
cd cppfront
git clone --recursive https://github.com/modern-cmake/cppfront
cd cppfront
git checkout 581f1aa
cd ..
cmake -S cppfront -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./target
cmake --build build --target install

