cmake_minimum_required(VERSION 3.29)
project(example)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CXX_COMPILER clang++)
set(CXX_STANDARD 23)
# set(CPPFRONT_FLAGS -pure-cpp2 )

find_package(cppfront REQUIRED)

add_executable(example main.cpp2)

set(cpp2headers 
    main.h2
)

cppfront_generate_cpp(cpp1headers ${cpp2headers})
target_sources(example PUBLIC ${cpp1headers})


set(BIN_DIR "${CMAKE_SOURCE_DIR}/bin")

set_target_properties(example PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}/$<0:>)
set_target_properties(example PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${BIN_DIR}/$<0:>)


set(_libtorch_dir "${CMAKE_SOURCE_DIR}/ext/libtorch")


if(MSVC)
  set(_libtorch_url "https://download.pytorch.org/libtorch/nightly/cpu/libtorch-win-shared-with-deps-latest.zip")
elseif(APPLE)
  set(_libtorch_url "https://download.pytorch.org/libtorch/nightly/cpu/libtorch-macos-latest.zip")
else()
  # TODO(tsoj) find right version for installed CUDA version
  # TODO(tsoj) only use if CUDA is enabled
  # set(_libtorch_url "https://download.pytorch.org/libtorch/nightly/cu121/libtorch-cxx11-abi-shared-with-deps-latest.zip")
  set(_libtorch_url "https://download.pytorch.org/libtorch/nightly/cpu/libtorch-cxx11-abi-shared-with-deps-latest.zip")
endif()

if(NOT EXISTS "${_libtorch_dir}")
  include(FetchContent)
  FetchContent_Populate(libtorchsdk SOURCE_DIR ${_libtorch_dir} URL ${_libtorch_url})
endif()

find_package(Torch REQUIRED  NO_MODULE PATHS "${_libtorch_dir}/share/cmake/Torch")

if(TORCH_FOUND)
  message(STATUS "TORCH_INCLUDE_DIRS:    ${TORCH_INCLUDE_DIRS}")
  message(STATUS "TORCH_LIBRARIES:       ${TORCH_LIBRARIES}")
  message(STATUS "TORCH_CXX_FLAGS:       ${TORCH_CXX_FLAGS}")
  message(STATUS "TORCH_INSTALL_PREFIX:  ${TORCH_INSTALL_PREFIX}")
endif()


set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")
target_link_libraries(example PUBLIC "${TORCH_LIBRARIES}")

#copy dlls
if (MSVC)
  # TODO(tsoj) not tested
  file(GLOB TORCH_DLLS "${_libtorch_dir}/lib/*.dll")
  add_custom_target(CopyTorchRuntimeFiles ALL ${CMAKE_COMMAND} -E make_directory
            ${BIN_DIR}/$<0:>
          COMMAND ${CMAKE_COMMAND} -E copy_if_different ${TORCH_DLLS}
            ${BIN_DIR}/$<0:>
          WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
          VERBATIM COMMAND_EXPAND_LISTS)
endif()
