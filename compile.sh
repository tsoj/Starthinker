#!/bin/bash

set -e

mkdir -p build
mkdir -p bin
cd build
CMAKE_GENERATOR=Ninja cmake -Dcppfront_DIR=./ext/cppfront/target/share/cmake/cppfront ..
cmake --build .