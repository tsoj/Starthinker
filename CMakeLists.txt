cmake_minimum_required(VERSION 3.29)
project(example)

find_package(cppfront REQUIRED)

add_executable(main main.cpp2)


set(BIN_DIR "${CMAKE_SOURCE_DIR}/bin")

set_target_properties(main PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}/$<0:>)
set_target_properties(main PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${BIN_DIR}/$<0:>)