cmake_minimum_required(VERSION 3.29)
project(Starthinker)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CXX_COMPILER clang++)
set(CXX_STANDARD 23)
# set(CPPFRONT_FLAGS -pure-cpp2 )

find_package(cppfront REQUIRED)

add_executable(Starthinker src/main.cpp2)

set(cpp2headers 
    src/main.h2
)

cppfront_generate_cpp(cpp1headers ${cpp2headers})
target_sources(Starthinker PUBLIC ${cpp1headers})


set(BIN_DIR "${CMAKE_SOURCE_DIR}/bin")

set_target_properties(Starthinker PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR}/$<0:>)
set_target_properties(Starthinker PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${BIN_DIR}/$<0:>)


set(LIBTORCH_DIR "${CMAKE_SOURCE_DIR}/ext/libtorch")

if(MSVC)
  set(LIBTORCH_URL "https://download.pytorch.org/libtorch/nightly/cpu/libtorch-win-shared-with-deps-latest.zip")
elseif(APPLE)
  set(LIBTORCH_URL "https://download.pytorch.org/libtorch/nightly/cpu/libtorch-macos-latest.zip")
else()
  # TODO(tsoj) find right version for installed CUDA version
  # TODO(tsoj) only use if CUDA is enabled
  # set(LIBTORCH_URL "https://download.pytorch.org/libtorch/nightly/cu121/libtorch-cxx11-abi-shared-with-deps-latest.zip")
  set(LIBTORCH_URL "https://download.pytorch.org/libtorch/nightly/cpu/libtorch-cxx11-abi-shared-with-deps-latest.zip")
endif()

if(NOT EXISTS "${LIBTORCH_DIR}")
  include(FetchContent)
  FetchContent_Populate(libtorchsdk SOURCE_DIR ${LIBTORCH_DIR} URL ${LIBTORCH_URL})
endif()

find_package(Torch REQUIRED NO_MODULE PATHS "${LIBTORCH_DIR}/share/cmake/Torch")

if(TORCH_FOUND)
  message(STATUS "TORCH_INCLUDE_DIRS:    ${TORCH_INCLUDE_DIRS}")
  message(STATUS "TORCH_LIBRARIES:       ${TORCH_LIBRARIES}")
  message(STATUS "TORCH_CXX_FLAGS:       ${TORCH_CXX_FLAGS}")
  message(STATUS "TORCH_INSTALL_PREFIX:  ${TORCH_INSTALL_PREFIX}")
endif()


set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")
target_link_libraries(Starthinker PUBLIC "${TORCH_LIBRARIES}")

# The following code block is suggested to be used on Windows.
# According to https://github.com/pytorch/pytorch/issues/25457,
# the DLLs need to be copied to avoid memory errors.
if (MSVC)
  file(GLOB TORCH_DLLS "${LIBTORCH_DIR}/lib/*.dll")
  add_custom_command(TARGET Starthinker
                     POST_BUILD
                     COMMAND ${CMAKE_COMMAND} -E copy_if_different
                     ${TORCH_DLLS} # TODO(tsoj) not tested
                     $<TARGET_FILE_DIR:Starthinker>)
endif (MSVC)
